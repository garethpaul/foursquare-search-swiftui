---
title: Foursquare SwiftUI Checkout Credential Boundary
date: 2026-06-12
status: completed
execution: code
---

# Foursquare SwiftUI Checkout Credential Boundary

## Summary

Make the hosted workflow match its credential-free documentation by disabling
checkout token persistence and enforcing that structure locally.

## Requirements

- Keep exactly one commit-pinned checkout step.
- Set `persist-credentials: false` on that step.
- Preserve read-only permissions, the macOS runner, Xcode project parsing,
  timeout, cancellation, and `make check` entry point.
- Reject workflow, evidence, and guidance regressions.

## Verification

- The local `make check` passed; Xcode project parsing was truthfully skipped
  because `xcodebuild` is unavailable on the Linux host.
- The rooted gate passed from an external working directory.
- Missing protection, duplicate checkout, incomplete evidence, and missing
  guidance hostile mutations were rejected.
- `git diff --check` and shell syntax validation passed.
