# Venue Fetcher Root Ownership

status: implementation_complete

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
- Local `swiftc` and `xcodebuild` are unavailable, so hosted macOS compile and
  simulator-build verification remain pending.
