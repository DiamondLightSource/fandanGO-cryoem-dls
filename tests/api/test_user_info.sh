#!/bin/bash
# Test: Query current user info
# Purpose: Verify token is valid and user is recognized by ARIA
#
# Expected: Returns current user details
# If fails: Token/authentication issues

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: Query Current User Info ==="
echo "Purpose: Verify token is valid and user is recognized"
echo

check_prerequisites
load_env

# Try userItem query
echo "Querying user info..."
echo

run_query '{ userItems { id username email } }' --endpoint beta

echo
echo "Expected: Current user details (id, username, email)"
