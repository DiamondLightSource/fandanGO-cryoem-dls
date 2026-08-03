# ARIA API Verification Tests

Manual verification tests for ARIA GraphQL API connectivity and permissions.
These tests help diagnose authentication and authorisation issues with the ARIA beta environment.

## Status: not currently runnable

These scripts call a GraphQL runner (`node run.js`) that lived outside this repository, in a personal
workspace at `$ERIC_ROOT/.claude/skills/graphql`. That runner no longer exists - only its
`node_modules` directory survives - so `run_query` in `common.sh` will fail.

They are committed as the record of the ARIA API investigation rather than as an executable suite: the
GraphQL queries, variables and endpoints in each script are exactly what was sent, and `FINDINGS.md`
records what came back. Reviving them means supplying any GraphQL client that can post an authenticated
query, and repointing `run_query`.

## Prerequisites

1. ARIA credentials configured in `$ERIC_ROOT/tmp/aria-beta.env`
2. A GraphQL runner at `$ERIC_ROOT/.claude/skills/graphql` exposing `run.js` (see Status above)
3. Node.js installed

## Environment Setup

The tests expect `ERIC_ROOT` to point to the workspace root, or will auto-detect if run from within the workspace.

```bash
export ERIC_ROOT=/home/vredchenko/dev/ERIC
```

## Running Tests

Run all tests:
```bash
./run_all.sh
```

Run individual tests:
```bash
./test_buckets_with_filters.sh
./test_facilities.sh
./test_introspection.sh
./test_visit_permissions.sh
./test_create_bucket.sh
```

## Test Descriptions

| Test | Purpose |
|------|---------|
| `test_introspection.sh` | Schema introspection - verifies basic GraphQL connectivity |
| `test_user_info.sh` | Query current user - verifies token is valid and user recognised |
| `test_facilities.sh` | Query facilities - verifies read access to facility data |
| `test_visit_by_id.sh` | Query visit by ID - verifies visit data access |
| `test_buckets_with_filters.sh` | Query buckets with entity filters - tests permission scoping |
| `test_visit_permissions.sh` | Query visit permissions - verifies permission API access |
| `test_create_bucket.sh` | Create a bucket - tests write permissions (run after reads work) |

## Known Visit IDs for Testing

From ARIA dev team - user has admin permissions for DLS facility:
- Visit 2842
- Visit 2460
- Visit 2106

## Interpreting Results

- **401 Unauthorized**: Permission check failed - see investigation notes
- **500 Internal Server Error**: Server-side issue - escalate to ARIA team
- **Empty array `[]`**: Query succeeded, no data exists (expected for new visits)
- **Data returned**: Full success

## Findings

See `FINDINGS.md` for detailed test results and analysis from 2026-01-29.
