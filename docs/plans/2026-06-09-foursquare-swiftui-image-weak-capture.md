---
title: Foursquare SwiftUI Image Weak Capture
date: 2026-06-09
status: completed
execution: static-contract
---

# Foursquare SwiftUI Image Weak Capture

## Context

`ImageLoader` retains its `URLSessionDataTask` so the request can be cancelled
when the loader is released. The task callback still captured the loader
strongly, which could keep the observable object alive until the request
finished and make `deinit` cancellation less useful for abandoned image views.

## Goals

- Preserve HTTPS-with-host image URL validation.
- Preserve retained task cancellation in `deinit`.
- Capture `ImageLoader` weakly in the URLSession callback.
- Avoid publishing image data after the loader has been released.
- Extend the static baseline and docs so the lifecycle contract stays visible.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
