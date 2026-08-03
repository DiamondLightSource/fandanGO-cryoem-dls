# ARIA API Test Findings

**Date**: 2026-01-29
**User**: val.redchenko@diamond.ac.uk (ID: 86)
**Environment**: ARIA Beta

## Summary

Authentication is working correctly. The issues are server-side:
- **Data-deposition API** returns **401 Unauthorized** even with proper entity filters
- **Access/Permission APIs** return **500 Internal Server Error**
- **Site queries** return **401 Unauthorized** (except `mySitesItems`)

## Test Results

| Test | Endpoint | Result | Notes |
|------|----------|--------|-------|
| Introspection | graphql-beta | SUCCESS | Schema access works |
| User Info | graphql-beta | SUCCESS | User recognised, ID=86 |
| **My Sites** | **graphql-beta** | **SUCCESS** | **User has joined 1 site** |
| Sites List | graphql-beta | 401 Error | Cannot list all sites |
| Site Membership | graphql-beta | 500 Error | Server-side issue |
| Facilities | structuralbiology.eu | 500 Error | Server-side issue |
| Visit by ID | structuralbiology.eu | 500 Error | Server-side issue |
| Visit Permissions | structuralbiology.eu | 500 Error | Server-side issue |
| **Buckets (with filters)** | **datadeposition.beta** | **401 Unauthorized** | **Key finding** |

## Key Finding: Sites vs Visits Are Separate Concepts

**Sites and visits are separate concepts in ARIA:**
- **Sites** = user membership, GDPR consent, access routes (like "beta" vs "production")
- **Visits** = scientific visits to facilities, linked to proposals/access/calls

### Bucket Query Filters

When querying buckets, we provide:
- `aria_id` = visit ID (e.g., 2842)
- `aria_entity_type` = "visit"

**No site_id is provided** - `BucketFilters` doesn't have a site filter:
```
BucketFilters: id, aria_id, aria_entity_type, owner, embargoed_until, created, updated
```

### Visit Query Filters

`VisitFilters` also has **no site_id filter**:
```
VisitFilters: plid, status, order, confirmed, completed, cancelled, detail,
              tech_eval_positive, suspension_count, cid, access_id, proposal_id, call_id, id
```

**We cannot list visits per site** - there's no site filter, and `visitItems` returns 500 anyway.

## Key Finding: Site Membership

The user has joined one site:
```json
{
  "mySitesItems": [
    {
      "id": "15b465be-b577-4310-aea9-6c1476b19f2d",
      "username": "47f4d43c-d757-4d5c-b5f7-33fa20a43caa",
      "site_id": "4980de81-ccdd-492b-b510-ae18ffc173d9",
      "created": "2026-01-19 14:06:34"
    }
  ]
}
```

However:
- **Cannot query site details** (siteItem returns 401)
- **Cannot list all sites** (siteItems returns 401)
- **Cannot check membership status** (isMemberItems returns 500)

This confirms:
1. **Site membership exists** - the user joined a site on 2026-01-19
2. **Missing site membership is NOT the root cause** - the 401 persists despite site membership
3. The issue is server-side permission handling in the data-deposition API

## Bucket Query Issue

The bucket query returns 401 **even when using the same filter pattern as fandanGO-aria**:

```graphql
query($filters: BucketFilters) {
  bucketItems(filters: $filters) {
    id aria_id aria_entity_type owner created
  }
}

# Variables:
{"filters": {"aria_id": 2842, "aria_entity_type": "visit"}}
```

Error response:
```
FAEResolver: Status 401 - Unauthorized from
https://datadeposition.beta.api.aria.services/api/v1/bucket?_sort=order&_order=asc&length=0&filter[aria_id]=2842&filter[aria_entity_type]=visit
```

## Hypotheses Tested

| Hypothesis | Status | Evidence |
|------------|--------|----------|
| Missing filters cause 401 | Disproved | 401 persists with proper entity scoping |
| Missing site membership | Disproved | User has joined a site (mySitesItems) |
| Wrong site membership | Unknown | Cannot query site details (siteItem returns 401) |
| Server-side permission bug | **Likely** | Multiple APIs returning 401/500 |

## Next Steps

1. Keep the GitHub issue open - this is a legitimate ARIA bug
2. The ARIA team needs to investigate:
   - Why the data-deposition API returns 401 for a user with facility admin permissions
   - Why the access/permission APIs return 500 errors
   - Why siteItem/siteItems return 401 even for a user's own site
3. Ask ARIA team about site `4980de81-ccdd-492b-b510-ae18ffc173d9` - what site is this?
4. Test again after ARIA team responds

## Affected APIs

| API | Base URL | Issue |
|-----|----------|-------|
| Data Deposition | datadeposition.beta.api.aria.services | 401 on bucket queries |
| Pages (Sites) | pages.beta.api.aria.services | 401 on site queries |
| Profile | profile.beta.api.aria.services | 500 on membership queries |
| Access | beta.structuralbiology.eu | 500 on visit/facility queries |
| Permissions | beta.structuralbiology.eu | 500 on permission queries |
| User | (works) | No issues |
| My Sites | (works) | No issues |
| GraphQL Schema | graphql-beta.aria.services | No issues |
