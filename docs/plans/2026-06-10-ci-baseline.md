# Foursquare Search SwiftUI CI Baseline

## Status: Completed

## Context

`foursquare-search-swiftui` has a static transport and configuration baseline
behind `make check`. The repository needs that baseline to run in GitHub
Actions so URL, ATS, lifecycle, and documentation guardrails are checked before
review.

## Objectives

- Run the existing `make check` wrapper in GitHub Actions.
- Parse the checked-in Xcode project without live Foursquare credentials.
- Make the workflow presence part of the static baseline contract.

## Work Completed

- Added `.github/workflows/check.yml` to run `make check` on pushes, pull
  requests, and manual dispatches.
- Run on fixed `macos-15` so `make check` parses the Xcode project as well as
  the Info.plist and static transport guardrails.
- Pin checkout and Python setup actions by commit, use read-only permissions,
  cancel superseded runs, and bound the job with a timeout.
- Extended `scripts/check-baseline.sh` to require the CI workflow and this
  completed plan.
- Updated README, VISION, SECURITY, and CHANGES with the CI baseline.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`

## Follow-Up Candidates

- Add a simulator or device smoke job once the supported runtime baseline is
  documented; project parsing is already hosted.
