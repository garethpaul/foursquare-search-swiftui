---
title: Foursquare SwiftUI Venue Name Boundary
type: bugfix
status: completed
date: 2026-06-18
execution: code
---

# Foursquare SwiftUI Venue Name Boundary

## Context

The decoded Foursquare model requires `Venue.name` to be a string, but accepts
empty and whitespace-only values. `VenueFetcher` publishes those venues and
`VenueItemView` renders the raw value, so a syntactically valid response can
produce a blank primary label. Existing response, envelope, size, redirect,
and lifecycle boundaries do not validate this presentation-critical field.

## Prioritized Engineering Tasks

1. **P0: Reject blank venue names before publication.** Normalize surrounding
   whitespace and omit venues whose required name becomes empty.
2. **P1: Render the normalized value.** Ensure accepted venue rows display the
   same normalized name used by the publication boundary.
3. **P1: Execute the production policy.** Compile the Foundation-only source in
   a standalone Swift harness on supported hosts.
4. **P2: Preserve the boundary.** Add mutation-sensitive static contracts,
   synchronized guidance, and truthful completed verification evidence.

## Requirements

- Add a Foundation-only policy that returns a trimmed nonempty venue name or
  rejects the value.
- Filter decoded venues through that policy before updating published state.
- Render the normalized name in `VenueItemView` without force unwrapping.
- Preserve valid Unicode text and trim only surrounding whitespace/newlines.
- When every decoded venue has an invalid name, retain the existing
  `No venues found.` empty-state behavior.
- Compile the production policy in a focused standalone harness when `swiftc`
  is available and preserve truthful skips elsewhere.
- Keep existing URL, redirect, timeout, response, size, envelope, task
  lifecycle, and image boundaries unchanged.

## Scope Boundaries

- Do not modify the generated Quicktype model schema or make optional fields
  required.
- Do not add a business-name length limit, character allowlist, or locale
  transformation.
- Do not change category, address, icon, venue ordering, or network behavior.
- Do not make live Foursquare requests or require credentials.
- Do not modernize deployment targets, signing, SwiftUI layout, or dependencies.
- Do not merge or close this stacked pull request or its predecessors without
  explicit authorization.

## Implementation Units

### U1. Production venue-name policy

Files:

- `FSQNearby/Service/FoursquareVenueTextPolicy.swift`
- `FSQNearby/Service/VenueFetcher.swift`
- `FSQNearby/View/VenueItemView.swift`
- `FSQNearby.xcodeproj/project.pbxproj`

Add a small normalization policy, reject invalid venues before publication,
and render the normalized name for accepted rows.

### U2. Executable and static regressions

Files:

- `Tests/FoursquareVenueTextPolicyTests/main.swift`
- `scripts/run-foursquare-venue-text-tests.sh`
- `scripts/check-baseline.sh`
- `Makefile`

Cover ordinary, surrounding-whitespace, newline, empty, whitespace-only, and
Unicode names using the production source. Preserve runner source wiring,
temporary cleanup, executable mode, Xcode target membership, publication
filtering, UI normalization, and Make integration.

### U3. Guidance and evidence

Files:

- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `AGENTS.md`
- `docs/plans/2026-06-18-foursquare-swiftui-venue-name-boundary.md`

Document the name-integrity boundary, exact commands run, platform skips, and
bounded exact-head hosted evidence.

## Test Scenarios

- Accept an ordinary venue name unchanged.
- Trim surrounding spaces and newlines from a valid name.
- Reject empty and whitespace-only names.
- Preserve valid non-ASCII venue text.
- Filter invalid venues before publishing `VenueFetcher.venues`.
- Render the normalized name without a force unwrap.
- Preserve the existing empty-state message when filtering removes every venue.
- Reject mutations that bypass normalization, remove required cases, omit Xcode
  target membership, or remove runner/Make integration.

## Verification

- Run the focused standalone Swift policy harness when `swiftc` is available.
- Run shell syntax checks plus repository-root and external-directory
  `make check`.
- Run isolated mutations for required-name rejection, Unicode preservation,
  publication filtering, UI normalization, target membership, runner/Make
  wiring, maintained guidance, and completed plan evidence.
- Audit the exact diff, executable modes, generated artifacts, whitespace,
  conflict markers, and credential-shaped additions.
- Require one bounded exact-head PR/check and security-alert snapshot after push.

## Risks

- Linux cannot execute Swift, xcodebuild, simulator, or UI behavior; hosted
  macOS remains authoritative for executable build coverage.
- Trimming changes display for names with intentional edge whitespace, but such
  whitespace is not meaningful venue identity and currently produces malformed
  labels.
- Filtering can turn a nonempty decoded response into the existing empty state;
  this is intentional because every rejected venue lacks a usable primary label.

## Verification Completed

The production policy trims accepted venue names, rejects empty and
whitespace-only names, preserves Unicode text, filters invalid venues before
publication, and provides the normalized name to the SwiftUI row. The source is
included in the application target and the focused runner compiles that same
production file on hosts with `swiftc`.

Repository-root and external-directory `make check` passed within Linux
capabilities. The gate truthfully skipped executable Swift tests and Xcode
project parsing because `swiftc` and `xcodebuild` are unavailable. Shell syntax,
exact-diff whitespace, runner mode, project membership, generated-artifact, and
credential-shaped addition checks passed.

Thirteen isolated mutations were rejected across normalization, required blank
and Unicode cases, publication filtering, row rendering, runner source and
mode, Xcode membership, Make wiring, guidance, plan status, and local evidence.

Both exact-head push and pull-request checks passed at implementation head
`8b17732daa3125d5bf373fb565881119b52889a0`. Push run `27739743924` and
pull-request run `27739751280` executed the production venue-text harness,
reported `FoursquareVenueTextPolicy behavioral tests passed`, completed the
full transport baseline, and built the simulator target successfully.

No live Foursquare request was made, and no credentials, private endpoint, or
user location data were required.
