---
title: Foursquare SwiftUI URL Host Validation
date: 2026-06-09
status: completed
execution: static-contract
---

# Foursquare SwiftUI URL Host Validation

## Context

The venue and image loaders already require HTTPS URLs with hosts before making
network requests. The baseline checker still only enforced the HTTPS portion,
so future edits could accidentally keep a scheme check while dropping host
validation.

## Goals

- Preserve local Foursquare venue-search endpoint configuration.
- Keep venue and image requests limited to HTTPS URLs with hosts.
- Extend the static baseline so host validation remains visible without Xcode.
- Avoid changing SwiftUI behavior or endpoint configuration in this pass.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`
