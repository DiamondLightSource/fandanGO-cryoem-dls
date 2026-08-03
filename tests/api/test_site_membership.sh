#!/bin/bash
# Test: Check site membership status
# Purpose: Verify if user is a member of specific sites
#
# Expected: Boolean membership status
# If false: User needs to join the site
# Note: These queries return 500 on beta - server-side issue

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: Check Site Membership ==="
echo "Purpose: Verify membership status for specific sites"
echo
echo "Note: These queries currently return 500 on beta environment."
echo "      This appears to be a server-side issue in the profile API."
echo

check_prerequisites
load_env

echo "Querying isMemberItems..."
echo "Note: This checks if the current user is a member of any site"
echo

run_query '{ isMemberItems { username site_id is_member } }' --endpoint beta || true

echo
echo "Expected: Membership records for the current user"
echo "If empty: User may not be a member of any site"
echo

# Also try querying siteMembersItems to see if we can view membership lists
echo "---"
echo
echo "Querying siteMembersItems (may require admin permissions)..."
echo

run_query '{ siteMembersItems { id username site_id email first_name last_name } }' --endpoint beta || true

echo
echo "Expected: List of site members (or 500 error - server-side issue)"
echo
