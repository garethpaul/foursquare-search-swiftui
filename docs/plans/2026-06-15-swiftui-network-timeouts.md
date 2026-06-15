---
title: SwiftUI Network Timeouts
type: reliability
date: 2026-06-15
status: in_progress
execution: code
---

# SwiftUI Network Timeouts

## Problem Frame

`VenueFetcher` creates a URL session from `.default`, and `ImageLoader` uses
`URLSession.shared`. Neither client records the latency bounds expected by the
sample. A stalled venue or image request can therefore depend on changing
platform defaults and keep its observable loading state unresolved longer than
the app intends.

## Prioritized Engineering Work

1. **P0 - Venue bounds:** configure explicit request and resource timeouts on
   the redirect-refusing venue session.
2. **P0 - Image bounds:** replace the shared session with an owned bounded
   session and invalidate it with the loader lifecycle.
3. **P1 - Contract enforcement:** verify exact values, construction order,
   request routing, cancellation, and session invalidation.
4. **P1 - Guidance:** document the bounds without claiming Apple or live API
   runtime evidence from Linux.

## Requirements

- R1. Venue and image sessions must each use a 15-second request timeout and a
  30-second resource timeout.
- R2. Timeout assignments must precede session construction.
- R3. Venue requests must retain the redirect-rejecting delegate and route
  through the dedicated venue session.
- R4. Image requests must route through an owned image session instead of
  `URLSession.shared`.
- R5. `ImageLoader.deinit` must cancel the task and invalidate the owned
  session.
- R6. Response provenance, media type, payload limits, main-queue publication,
  and public view behavior must remain unchanged.
- R7. Static contracts must reject removal, widening, ordering, shared-session
  fallback, lifecycle drift, guidance removal, and incomplete evidence.

## Implementation Units

### U1: Bound Venue Networking

Files:

- `FSQNearby/Service/VenueFetcher.swift`

### U2: Own And Bound Image Networking

Files:

- `FSQNearby/Service/ImageLoader.swift`

### U3: Enforce And Document

Files:

- `scripts/check-swiftui-network-timeouts.py`
- `scripts/check-baseline.sh`
- `AGENTS.md`
- `CHANGES.md`
- `README.md`
- `SECURITY.md`
- `VISION.md`
- `docs/plans/2026-06-15-swiftui-network-timeouts.md`

## Verification

- Focused static timeout/lifecycle checker and shell syntax.
- Repository and external-directory `make check`, plus maintained aliases.
- Hostile mutations for venue/image timeout removal, widening, ordering,
  shared-session fallback, invalidation loss, guidance, and plan evidence.
- Exact diff, Xcode project, generated artifact, conflict marker, executable
  mode, and changed-line secret audits.

## Risks

- Slow endpoints may fail sooner than the platform defaults. Existing venue
  error publication and image empty-state behavior remain unchanged.
- The owned image session adds a lifecycle responsibility; explicit task
  cancellation and `invalidateAndCancel()` keep it bounded.
- Xcode, simulator/device, and live Foursquare/image endpoints remain outside
  Linux validation.

## Status: In Progress
