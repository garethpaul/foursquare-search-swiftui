# Foursquare Search SwiftUI CI Baseline

## Status: Completed

## Context

`foursquare-search-swiftui` has a static transport and configuration baseline
behind `make check`. The repository needs that baseline to run in GitHub
Actions so URL, ATS, lifecycle, and documentation guardrails are checked before
review.

## Objectives

- Run the existing `make check` wrapper in GitHub Actions.
- Keep the hosted job independent of Xcode and live Foursquare credentials.
- Make the workflow presence part of the static baseline contract.

## Work Completed

- Added `.github/workflows/check.yml` to run `make check` on pushes, pull
  requests, and manual dispatches.
- Set up Python 3.12 for the Info.plist parsing path used by the shell checker.
- Extended `scripts/check-baseline.sh` to require the CI workflow and this
  completed plan.
- Updated README, VISION, SECURITY, and CHANGES with the CI baseline.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`

## Follow-Up Candidates

- Add a macOS/Xcode build or UI smoke job once the supported Xcode and simulator
  baseline are documented.
