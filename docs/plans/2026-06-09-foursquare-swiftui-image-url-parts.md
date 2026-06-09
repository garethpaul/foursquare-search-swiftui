---
title: Foursquare SwiftUI Image URL Parts
date: 2026-06-09
status: completed
execution: code
---

## Context

`ImageLoader` already required HTTPS image URLs with hosts and cancelled retained
tasks when deallocated. Venue endpoint parsing also rejected embedded userinfo
and fragments, but image URLs still allowed those parts before starting
requests.

## Goals

- Reject image URLs with embedded username or password values.
- Reject image URLs with fragments because fragments are not sent to the server
  and should not influence fetch behavior.
- Preserve HTTPS host validation, retained task cancellation, and weak callback
  captures.
- Extend static verification and docs for the image URL boundary.

## Implementation

- Added `url.user == nil`, `url.password == nil`, and `url.fragment == nil` to
  `ImageLoader.load`.
- Extended `scripts/check-baseline.sh`, README, SECURITY, VISION, and CHANGES.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`

Full project verification still requires a macOS/Xcode environment with the
legacy project toolchain installed.
