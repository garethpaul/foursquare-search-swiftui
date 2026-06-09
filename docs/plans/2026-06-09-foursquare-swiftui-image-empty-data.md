---
title: Foursquare SwiftUI Image Empty Data
date: 2026-06-09
status: completed
execution: code
---

## Context

`ImageLoader` already required HTTPS image URLs with hosts, rejected unsafe URL
parts, retained and cancelled request tasks, and used weak task captures. A
successful HTTP response with an empty body could still be published as image
data, leaving the view layer to handle unusable bytes.

## Goals

- Ignore successful image responses with empty bodies.
- Preserve HTTPS host validation, URL-part rejection, task cancellation, and
  weak callback captures.
- Keep the change local to the image loader and static baseline.
- Document the image data boundary for future loader changes.

## Implementation

- Added `!data.isEmpty` to the image response guard before publishing data.
- Extended `scripts/check-baseline.sh`, README, SECURITY, VISION, and CHANGES.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Full project verification still requires a macOS/Xcode environment with the
legacy project toolchain installed.
