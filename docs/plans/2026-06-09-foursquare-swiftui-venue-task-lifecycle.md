---
title: Foursquare SwiftUI Venue Task Lifecycle
date: 2026-06-09
status: completed
execution: static-contract
---

# Foursquare SwiftUI Venue Task Lifecycle

## Context

`ImageLoader` already retains and cancels image URLSession tasks, but
`VenueFetcher` started its venue request as an unretained task from `init`.
The weak capture avoided updating a released fetcher, but the network request
could still continue after the fetcher lifecycle ended.

## Goals

- Preserve HTTPS-with-host venue URL validation.
- Retain the venue URLSession task on the fetcher.
- Cancel any in-flight venue request when the fetcher is deallocated.
- Extend static verification so venue and image request lifecycles stay aligned.

## Implementation

- Added a retained `URLSessionDataTask` property to `VenueFetcher`.
- Added `deinit` cancellation for in-flight venue requests.
- Resumed the retained task explicitly.
- Updated `scripts/check-baseline.sh`, README, VISION, and CHANGES.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode verification is still skipped locally because `xcodebuild` is not
installed in this environment.
