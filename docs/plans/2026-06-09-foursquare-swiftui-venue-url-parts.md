---
title: Foursquare SwiftUI Venue URL Parts
date: 2026-06-09
status: completed
execution: code
---

## Context

The SwiftUI app loads its venue-search endpoint from the local
`FOURSQUARE_VENUE_SEARCH_URL` build setting. The current guard requires HTTPS
and a host, but it still accepts embedded username/password userinfo and URL
fragments. Query strings remain allowed because local endpoint configuration may
include normal request parameters.

## Goals

- Keep the local endpoint scheme and host validation.
- Reject embedded username/password userinfo.
- Reject URL fragments before starting venue requests.
- Preserve venue task retention, cancellation, and visible error states.

## Implementation

- Added `url.user`, `url.password`, and `url.fragment` checks in
  `VenueFetcher.venueSearchURL()`.
- Extended `scripts/check-baseline.sh` with static guards for the URL parts.
- Updated README, VISION, and CHANGES with the endpoint contract.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode project listing is still skipped locally because `xcodebuild` is not
installed in this environment.
