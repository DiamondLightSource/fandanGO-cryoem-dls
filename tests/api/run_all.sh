#!/bin/bash
# Run all ARIA API verification tests
# Stops on first failure unless --continue flag is passed

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONTINUE_ON_FAILURE=false
SKIP_WRITE_TESTS=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --continue)
            CONTINUE_ON_FAILURE=true
            shift
            ;;
        --include-writes)
            SKIP_WRITE_TESTS=false
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--continue] [--include-writes]"
            exit 1
            ;;
    esac
done

echo "========================================"
echo "ARIA API Verification Tests"
echo "========================================"
echo
echo "Options:"
echo "  Continue on failure: $CONTINUE_ON_FAILURE"
echo "  Skip write tests: $SKIP_WRITE_TESTS"
echo

run_test() {
    local test_script="$1"
    local test_name=$(basename "$test_script" .sh)

    echo
    echo "----------------------------------------"
    echo "Running: $test_name"
    echo "----------------------------------------"

    if $CONTINUE_ON_FAILURE; then
        "$test_script" || echo "FAILED: $test_name"
    else
        "$test_script"
    fi
}

# Read-only tests (safe to run)
run_test "$SCRIPT_DIR/test_introspection.sh"
run_test "$SCRIPT_DIR/test_user_info.sh"
run_test "$SCRIPT_DIR/test_sites_list.sh"
run_test "$SCRIPT_DIR/test_my_sites.sh"
run_test "$SCRIPT_DIR/test_site_membership.sh"
run_test "$SCRIPT_DIR/test_facilities.sh"
run_test "$SCRIPT_DIR/test_visit_by_id.sh"
run_test "$SCRIPT_DIR/test_buckets_with_filters.sh"
run_test "$SCRIPT_DIR/test_visit_permissions.sh"

# Write tests (create real data)
if ! $SKIP_WRITE_TESTS; then
    echo
    echo "========================================"
    echo "Write Tests (creates real data)"
    echo "========================================"
    run_test "$SCRIPT_DIR/test_create_bucket.sh"
else
    echo
    echo "========================================"
    echo "Skipping write tests (use --include-writes to enable)"
    echo "========================================"
fi

echo
echo "========================================"
echo "All tests completed"
echo "========================================"
