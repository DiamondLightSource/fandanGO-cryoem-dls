#!/bin/bash
# Test: Create a bucket
# Purpose: Verify write permissions after reads work
#
# WARNING: This creates real data in the ARIA beta environment.
# Only run after read tests succeed.
#
# Expected: Returns created bucket with id
# If 401: User lacks write permissions for this visit

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: Create Bucket ==="
echo "Purpose: Verify write permissions"
echo "Visit ID: $TEST_VISIT_ID"
echo
echo "WARNING: This creates real data in ARIA beta environment"
echo

check_prerequisites
load_env

# Embargo date 1 year from now
EMBARGO_DATE=$(date -d "+1 year" +%Y-%m-%dT00:00:00Z 2>/dev/null || date -v+1y +%Y-%m-%dT00:00:00Z)

QUERY='mutation($input: CreateBucketInput!) { createDataBucket(input: $input) { id aria_id aria_entity_type owner created } }'
VARIABLES="{\"input\": {\"aria_id\": $TEST_VISIT_ID, \"aria_entity_type\": \"visit\", \"embargoed_until\": \"$EMBARGO_DATE\"}}"

echo "Query: $QUERY"
echo "Variables: $VARIABLES"
echo

run_query "$QUERY" --variables "$VARIABLES" --endpoint beta

echo
echo "Expected: Created bucket object with id, aria_id, aria_entity_type"
