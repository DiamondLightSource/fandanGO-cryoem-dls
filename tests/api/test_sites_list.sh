#!/bin/bash
# Test: List all available sites
# Purpose: See what sites exist that the user could join
#
# Expected: List of all ARIA sites
# Useful for: Identifying which site(s) the user should join
# Note: This query returns 401 on beta - site list may require admin permissions

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: List All Sites ==="
echo "Purpose: See what sites are available to join"
echo
echo "Note: This query often returns 401 on beta environment."
echo "      Site listing may require admin permissions."
echo

check_prerequisites
load_env

echo "Querying siteItems..."
echo

run_query '{ siteItems { id name title home_uri perm_attribute active is_admin } }' --endpoint beta || true

echo
echo "Expected: List of all available sites (or 401 if restricted)"
echo "Look for: DLS-related sites or beta/test sites"
echo "Note: is_admin indicates if current user is admin for that site"
echo
