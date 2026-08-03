#!/bin/bash
# Test: Query visit permissions
# Purpose: Verify user has expected permissions for test visit
#
# Expected: Returns permission scopes for the visit
# If 401: User lacks permission API access

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: Query Visit Permissions ==="
echo "Purpose: Verify user permissions for test visit"
echo "Visit ID: $TEST_VISIT_ID"
echo

check_prerequisites
load_env

QUERY='query($filters: VisitPermissionFilters) { visitPermissionItems(filters: $filters) { entity_id scopes } }'
VARIABLES="{\"filters\": {\"entity_id\": $TEST_VISIT_ID}}"

echo "Query: $QUERY"
echo "Variables: $VARIABLES"
echo

run_query "$QUERY" --variables "$VARIABLES" --endpoint beta

echo
echo "Expected: Permission scopes for visit $TEST_VISIT_ID"
