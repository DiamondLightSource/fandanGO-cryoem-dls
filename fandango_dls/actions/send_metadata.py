"""
Send metadata action for DLS Cryo-EM plugin

Sends extracted metadata to ARIA system
"""

import json
from datetime import datetime
from fandango_dls.db.sqlite_db import get_project_metadata, get_project_data_location

# Import ARIA client from fandanGO-aria
try:
    from fGOaria import AriaClient, Bucket, Field
except ImportError:
    AriaClient = None
    print("Warning: fandanGO-aria not available. Install to enable ARIA integration.")


def send_metadata_to_aria(project_name, visit_id):
    """
    Send FandanGO project metadata to ARIA

    Args:
        project_name (str): FandanGO project name
        visit_id (int): ARIA visit ID

    Returns:
        success (bool): Whether submission succeeded
        info (dict): Information about created ARIA entities or error message
    """

    print(f'FandanGO will send metadata for {project_name} project to ARIA...')
    success = False
    info = None

    if AriaClient is None:
        info = "ARIA client not available. Please install fandanGO-aria package."
        print(info)
        return success, info

    try:
        # Retrieve stored metadata from database
        metadata_json_str = get_project_metadata(project_name)
        if not metadata_json_str:
            info = f"No metadata found for project {project_name}. Run generate-metadata first."
            print(info)
            return success, info

        metadata = json.loads(metadata_json_str)

        # Initialize ARIA client and login
        aria = AriaClient(True)
        aria.login()

        # Create data bucket with embargo date (3 years from now)
        today = datetime.today()
        visit = aria.new_data_manager(int(visit_id), 'visit', True)
        embargo_date = datetime(today.year + 3, today.month, today.day).strftime('%Y-%m-%d')
        bucket = Bucket(visit.entity_id, visit.entity_type, embargo_date)
        visit.push(bucket)

        # Create record for DLS Cryo-EM metadata
        record_dls_cryoem = visit.create_record(bucket.id, 'DLS_CRYOEM')

        # Push SmartEM metadata as JSON field
        field = Field(record_dls_cryoem.id, 'JSON', metadata)
        visit.push(field)

        if not isinstance(field, Field):
            success = False
            info = "Failed to create metadata field in ARIA"
            return success, info

        # Add data location reference if available
        data_location = get_project_data_location(project_name)
        if data_location:
            record_data_location = visit.create_record(bucket.id, 'Generic')
            location_field = Field(record_data_location.id, 'DATA_LOCATION', data_location)
            visit.push(location_field)

        success = True
        print(f'Successfully sent metadata for project {project_name} to ARIA!')
        info = {
            'bucket': bucket.__dict__,
            'record': record_dls_cryoem.__dict__,
            'field': field.__dict__,
            'visit_id': visit_id
        }

    except json.JSONDecodeError as e:
        info = f"Failed to parse stored metadata: {e}"
        print(info)
    except Exception as e:
        info = f"Failed to send metadata to ARIA: {e}"
        print(info)

    return success, info


def perform_action(args):
    """
    Entry point for the send-metadata action

    Args:
        args (dict): Dictionary containing:
            - name: Project name
            - visit-id: ARIA visit ID

    Returns:
        dict: Results dictionary with success status and info
    """
    success, info = send_metadata_to_aria(args['name'], args['visit_id'])
    results = {'success': success, 'info': info}
    return results
