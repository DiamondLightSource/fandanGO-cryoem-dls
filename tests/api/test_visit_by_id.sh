#!/bin/bash
# Test: Query visit by ID
# Purpose: Verify we can read visit data directly (not through bucket/permission APIs)
#
# Expected: Returns visit details for the specified ID
# If 401/500: General API access issues

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: Query Visit by ID ==="
echo "Purpose: Verify we can read visit data directly"
echo "Visit ID: $TEST_VISIT_ID"
echo

check_prerequisites
load_env

QUERY='query($filters: VisitFilters) { visitItems(filters: $filters) { id proposal_id status confirmed completed } }'
VARIABLES="{\"filters\": {\"id\": $TEST_VISIT_ID}}"

echo "Query: $QUERY"
echo "Variables: $VARIABLES"
echo

run_query "$QUERY" --variables "$VARIABLES" --endpoint beta

echo
echo "Expected: Visit details for ID $TEST_VISIT_ID"
