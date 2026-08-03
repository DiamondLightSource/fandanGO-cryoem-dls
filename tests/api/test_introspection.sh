#!/bin/bash
# Test: Schema introspection
# Purpose: Verify basic GraphQL connectivity and discover available queries
#
# Expected: Returns list of query field names
# If 401: Authentication completely broken

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: Schema Introspection ==="
echo "Purpose: Verify basic GraphQL connectivity"
echo

check_prerequisites
load_env

echo "Querying schema for available query types..."
echo

run_query '{ __schema { queryType { fields { name } } } }' --endpoint beta

echo
echo "Look for: bucketItems, facilityItems, visitPermissionItems, proposalPermissionItems"
