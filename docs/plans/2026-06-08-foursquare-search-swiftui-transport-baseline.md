# Foursquare Search SwiftUI Transport Baseline

date: 2026-06-08
status: completed

## Context

Foursquare Search SwiftUI is a compact SwiftUI venue-list sample. The project
had a recorded P2 finding for a global App Transport Security bypass and used a
hardcoded placeholder for the Foursquare venue-search URL.

## Completed Scope

- Removed `NSAllowsArbitraryLoads` from `Info.plist`.
- Added `FoursquareVenueSearchURL` wired to the
  `FOURSQUARE_VENUE_SEARCH_URL` local build setting.
- Required HTTPS for venue search and image loading.
- Guarded venue decoding and removed force-unwrapping of missing response data.
- Added visible empty/error states for venue loading.
- Removed force-unwrapping of optional category and address fields.
- Stopped image loading from recursively refetching after data changes.
- Removed runtime `print` diagnostics from network loading.
- Added basic empty/error venue states and safer optional rendering in SwiftUI
  views.
- Added `scripts/check-baseline.sh` and `make check` for repeatable static
  verification.
- Documented the resolved ATS finding.

## Verification

- `make check`

## Follow-Ups

- Verify the app in Xcode with a local HTTPS Foursquare venue-search URL.
- Add fixture-based decoding tests if model changes continue.
