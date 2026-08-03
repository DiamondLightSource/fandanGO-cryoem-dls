#!/bin/bash
# Test: Query sites the current user has joined
# Purpose: Check if user has joined any sites (required for access)
#
# Expected: List of sites user has joined
# If empty: User needs to join a site via ARIA web UI (GDPR consent)
# If 401/403: Site membership may be required for API access

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo "=== Test: Query My Sites ==="
echo "Purpose: Check which sites the user has joined"
echo
echo "From ARIA Access Glossary:"
echo "  - Users must 'join' a site by logging in and consenting to GDPR data processing"
echo "  - Sites segregate users, access routes, facilities, and content"
echo "  - Site membership may be required for API access"
echo

check_prerequisites
load_env

echo "Querying mySitesItems..."
echo

run_query '{ mySitesItems { id username site_id created } }' --endpoint beta

echo
echo "Expected: List of sites the user has joined (site_id is a UUID)"
echo "If empty: User may need to join a site via ARIA web UI"
echo
