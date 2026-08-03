#!/bin/bash
# Test: Query facilities
# Purpose: Verify read access to facility data (should include DLS)
#
# Expected: Returns list of facilities including Diamond Light Source
# If 401: User lacks facility read permissions

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: Query Facilities ==="
echo "Purpose: Verify read access to facility data"
echo

check_prerequisites
load_env

echo "Querying all facilities..."
echo

run_query '{ facilityItems { id name } }' --endpoint beta

echo
echo "Expected: List should include Diamond Light Source (DLS)"
