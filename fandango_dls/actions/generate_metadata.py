"""
Generate metadata action for DLS Cryo-EM plugin

Extracts metadata from SmartEM API and stores it for later ARIA submission
"""

import configparser
import os
import json
from fandango_dls.db.sqlite_db import update_project
from fandango_dls.utils.smartem_client import FandanGOSmartEMClient

config = configparser.ConfigParser()
config.read(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'config.yaml'))
smartem_api_url = config['SMARTEM'].get('API_URL', 'http://localhost:8000')


def generate_metadata_from_smartem(project_name, acquisition_id):
    """
    Extract metadata from SmartEM API for a given acquisition

    Args:
        project_name (str): FandanGO project name
        acquisition_id (str): UUID of the SmartEM acquisition

    Returns:
        success (bool): Whether extraction succeeded
        info (dict): Information about the extracted metadata
    """

    print(f'FandanGO will extract metadata from SmartEM for project {project_name}...')
    success = False
    info = None

    try:
        # Connect to SmartEM API
        with FandanGOSmartEMClient(base_url=smartem_api_url) as client:
            print(f'... connecting to SmartEM API at {smartem_api_url}')

            # Extract full acquisition metadata
            print(f'... extracting metadata for acquisition {acquisition_id}')
            metadata = client.extract_acquisition_metadata(acquisition_id)

            # Convert to JSON string for storage
            metadata_json = json.dumps(metadata, indent=2)

            # Store in database
            update_project(project_name, 'acquisition_id', acquisition_id)
            update_project(project_name, 'metadata_json', metadata_json)

            # Generate summary info
            num_grids = len(metadata.get('grids', []))
            num_grid_squares = sum(
                len(g.get('grid_squares', []))
                for g in metadata.get('grids', [])
            )

            success = True
            info = {
                'acquisition_id': acquisition_id,
                'num_grids': num_grids,
                'num_grid_squares': num_grid_squares,
                'acquisition_name': metadata.get('acquisition', {}).get('name', 'Unknown')
            }

            print(f'... successfully extracted metadata for {num_grids} grids, {num_grid_squares} grid squares')

    except ImportError as e:
        info = (
            f'... SmartEM client not available. Please install smartem-decisions package '
            f'or add it to PYTHONPATH. Error: {e}'
        )
        print(info)

    except Exception as e:
        info = f'... failed to extract metadata from SmartEM: {e}'
        print(info)

    return success, info


def perform_action(args):
    """
    Entry point for the generate-metadata action

    Args:
        args (dict): Dictionary containing:
            - name: Project name
            - acquisition-id: SmartEM acquisition UUID

    Returns:
        dict: Results dictionary with success status and info
    """
    success, info = generate_metadata_from_smartem(args['name'], args['acquisition_id'])
    results = {'success': success, 'info': info}
    return results
