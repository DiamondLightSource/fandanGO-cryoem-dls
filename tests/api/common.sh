#!/bin/bash
# Common setup for ARIA API tests

# Auto-detect ERIC_ROOT if not set
if [[ -z "$ERIC_ROOT" ]]; then
    # Walk up from script location to find workspace root
    # Path: repos/DiamondLightSource/fandanGO-cryoem-dls/tests/api -> ERIC (5 levels)
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    ERIC_ROOT="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"
fi

GRAPHQL_SKILL_DIR="$ERIC_ROOT/.claude/skills/graphql"
ENV_FILE="$ERIC_ROOT/tmp/aria-beta.env"

# Validate prerequisites
check_prerequisites() {
    if [[ ! -f "$ENV_FILE" ]]; then
        echo "ERROR: Environment file not found: $ENV_FILE"
        echo "Create it with ARIA_CONNECTION_USERNAME and ARIA_CONNECTION_PASSWORD"
        exit 1
    fi

    if [[ ! -d "$GRAPHQL_SKILL_DIR" ]]; then
        echo "ERROR: GraphQL skill not found: $GRAPHQL_SKILL_DIR"
        exit 1
    fi

    if ! command -v node &> /dev/null; then
        echo "ERROR: Node.js not found"
        exit 1
    fi
}

# Load environment and export for GraphQL skill
load_env() {
    source "$ENV_FILE"
    export ARIA_USERNAME="$ARIA_CONNECTION_USERNAME"
    export ARIA_PASSWORD="$ARIA_CONNECTION_PASSWORD"
}

# Run a GraphQL query
# Usage: run_query "query" [--variables '{"key": "value"}'] [--endpoint name]
run_query() {
    local query="$1"
    shift

    cd "$GRAPHQL_SKILL_DIR"
    node run.js "$query" "$@"
}

# Default test visit IDs (user has admin permissions for DLS)
TEST_VISIT_ID="${TEST_VISIT_ID:-2842}"
TEST_VISIT_ID_ALT1="${TEST_VISIT_ID_ALT1:-2460}"
TEST_VISIT_ID_ALT2="${TEST_VISIT_ID_ALT2:-2106}"
