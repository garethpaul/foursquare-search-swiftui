---
title: Foursquare SwiftUI Image Task Lifecycle
date: 2026-06-09
status: completed
execution: static-contract
---

# Foursquare SwiftUI Image Task Lifecycle

## Context

`ImageLoader` validates HTTPS image URLs and publishes downloaded data to
SwiftUI views. The loader created a URLSession task as a local value, so the
request could continue after the loader was deallocated and there was no
lifecycle hook for cancelling no-longer-needed image work.

## Goals

- Preserve HTTPS-with-host image URL validation.
- Retain the image URLSession task on the loader.
- Cancel any in-flight image request when the loader is deallocated.
- Extend the static baseline and docs so the lifecycle behavior remains
  visible without Xcode.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`
