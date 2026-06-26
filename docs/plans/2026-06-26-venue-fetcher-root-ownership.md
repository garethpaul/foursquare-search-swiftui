# Venue Fetcher Root Ownership

status: completed

## Goal

Keep one venue request owner for the lifetime of the hosted SwiftUI root on the
project's iOS 13 deployment target.

## Problem

`VenueListView` currently initializes `@ObservedObject var fetcher =
VenueFetcher()`. `ObservedObject` observes an externally owned reference; it
does not preserve an object created by a child view when SwiftUI reconstructs
that view. A redraw can therefore create a second fetcher and start another
venue download while the prior request is cancelled only when its old owner is
released.

## Implementation

1. Add a static ownership regression that rejects child construction.
2. Create one `VenueFetcher` in `ContentView`, the hosted scene root.
3. Inject that reference into `VenueListView` for observation.
4. Preserve the iOS 13.2 deployment target instead of adopting `StateObject`.
5. Run all Make aliases, the external Make gate, and an isolated hostile
   mutation restoring child construction.

## Verification

- The ownership checker fails against the original child-created fetcher.
- The focused ownership check and hostile child-construction mutation pass.
- `make lint`, `make test`, `make build`, and `make check` pass locally.
- The absolute external Makefile `make check` gate passes from `/tmp`.
- Local `swiftc` and `xcodebuild` are unavailable; hosted macOS supplied the
  authoritative executable policy, project parse, compile, and unsigned
  simulator-build evidence.
- Implementation commit `9a2d73fc78d8ea6c64f5c2376c536b4aa3a9fb0d`
  passed push Check run `28247639075`, pull-request Check run `28247642376`,
  and CodeQL run `28247640315` for Actions, Python, and Swift.
- PR #20 merged that implementation as merge commit
  `e76a3517bd73a26083d0a274093c57bb843b0feb` after the required checks passed.
- `git diff --check` passed, and no live Foursquare request or credential was
  used.
