#!/bin/bash
# Test: Query buckets WITH entity filters
# Purpose: Test if 401 error is caused by missing filters
#
# Background: fandanGO-aria always queries buckets with aria_id and aria_entity_type filters.
# The ARIA permission system checks canView() for each bucket, which requires entity scope.
# Unfiltered queries may fail because permission checks cannot be performed system-wide.
#
# Expected: Returns buckets for the visit (or empty array if none exist)
# If 401: Issue is NOT missing filters - escalate to ARIA team

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: Query Buckets with Filters ==="
echo "Purpose: Test if 401 error is caused by missing entity filters"
echo "Visit ID: $TEST_VISIT_ID"
echo

check_prerequisites
load_env

QUERY='query($filters: BucketFilters) { bucketItems(filters: $filters) { id aria_id aria_entity_type owner created } }'
VARIABLES="{\"filters\": {\"aria_id\": $TEST_VISIT_ID, \"aria_entity_type\": \"visit\"}}"

echo "Query: $QUERY"
echo "Variables: $VARIABLES"
echo

run_query "$QUERY" --variables "$VARIABLES" --endpoint beta

echo
echo "Expected: Array of buckets (possibly empty) OR 401 if server-side issue"
