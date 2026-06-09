---
title: Foursquare SwiftUI Image Decode Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

`ImageLoader` already ignores empty image response bodies before publishing
data. Non-empty bytes can still fail UIKit image decoding, and `IconView`
previously replaced the current icon with a blank `UIImage()` when decoding
failed.

The SwiftUI icon view should keep its current state when a response is not a
valid image payload.

## Goals

- Avoid replacing the current icon with a blank image for undecodable data.
- Preserve existing successful image rendering.
- Keep image validation visible in the repo baseline and docs.

## Implementation

- Guarded `UIImage(data:)` in `IconView.onReceive`.
- Updated the static baseline to require decode-safe image assignment.
- Extended README, SECURITY, VISION, CHANGES, and this completed plan.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Full Xcode build and simulator verification still require a macOS/Xcode
environment.
