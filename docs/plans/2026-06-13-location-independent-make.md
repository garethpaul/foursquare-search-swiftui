---
title: Location-Independent SwiftUI Verification
type: reliability
date: 2026-06-13
status: completed
execution: code
---

# Location-Independent SwiftUI Verification

## Summary

Resolve the maintained static checker from the loaded Makefile so every
documented gate works when Make is invoked outside the checkout.

## Requirements

- R1. Derive the repository root from `MAKEFILE_LIST`.
- R2. Invoke `scripts/check-baseline.sh` through its repository-rooted path.
- R3. Add a static contract that rejects caller-directory-relative invocation.
- R4. Preserve all SwiftUI, project, plist, venue/image transport, response
  metadata, final-URL provenance, privacy, workflow, and signing surfaces.
- R5. Record actual root and external-directory verification before completion.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` at repository
  root.
- Run the full gate from `/tmp` through the absolute Makefile path.
- Reject isolated hostile root-derivation, checker-path, documentation,
  plan-status, and verification-evidence mutations.
- Run shell syntax, plist/XML parsing, `git diff --check`, exact-path review,
  secret/signing inspection, and generated-artifact inspection.

## Non-Goals

- Changing application runtime, dependencies, project settings, signing,
  venue/image requests, or response validation.
- Claiming Xcode build, simulator, device, location, or live Foursquare/image
  execution.

## Work Completed

- Derived the repository root from the loaded Makefile and invoked the static
  checker through that absolute path.
- Extended the baseline with rooted-Makefile, completed-plan, external-run, and
  synchronized-guidance contracts.
- Preserved all SwiftUI, Xcode project, plist, venue/image transport,
  response-metadata, final-URL provenance, privacy, workflow, and signing
  surfaces unchanged.

## Verification Completed

- `make check`, `make lint`, `make test`, and `make build` passed at repository
  root.
- The full gate passed from /tmp through the absolute Makefile path.
- Five isolated hostile root-derivation, checker-path, documentation,
  plan-status, and verification-evidence mutations were rejected.
- Shell syntax, plist/XML parsing, `git diff --check`, exact-path review,
  added-line secret/signing inspection, and generated-artifact inspection
  passed.
- Xcode build, simulator, device, location, and live Foursquare/image behavior
  were unavailable and are not claimed.
