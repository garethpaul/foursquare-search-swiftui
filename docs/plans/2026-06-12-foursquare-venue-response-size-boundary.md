---
title: Foursquare Venue Response Size Boundary
date: 2026-06-12
status: completed
execution: code
---

## Context

Remote category images are capped at 5 MiB before publication, but venue search
JSON currently accepts any 2xx response size before decoding. A misconfigured
endpoint or oversized upstream response can therefore consume unnecessary
memory on a mobile device even though the sample only renders a short nearby
venue list.

## Goals

- Bound accepted venue search payloads before JSON decoding.
- Reject both oversized declared response lengths and oversized actual data.
- Preserve existing HTTPS URL validation, request cancellation, UI error
  handling, and Foursquare model decoding.
- Keep the limit explicit and small enough for the sample's nearby venue list.

## Implementation

- Add a 2 MiB venue response limit and temporary-file download to
  `VenueFetcher`.
- Require `expectedContentLength` to be unknown or within the limit.
- Require a non-empty temporary file within the same limit before loading and
  decoding it.
- Route rejected payloads through the existing generic no-data error state so
  no response body or endpoint details are exposed to users.
- Extend `scripts/check-baseline.sh`, README, VISION, SECURITY, and CHANGES to
  preserve the venue payload boundary.

## Verification

- `sh -n scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
- Hosted macOS `xcodebuild -list` project parsing

Runtime URLSession and UI behavior still require Xcode/device verification; the
repository has no dedicated test target.
