---
title: Location-Independent SwiftUI Verification
type: reliability
date: 2026-06-13
status: planned
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

Pending implementation.

## Verification Completed

Pending implementation and verification.
