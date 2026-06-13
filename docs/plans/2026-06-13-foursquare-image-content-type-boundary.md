---
title: Foursquare Image Content-Type Boundary
type: security
status: completed
date: 2026-06-13
---

# Foursquare Image Content-Type Boundary

## Summary

Reject remote image responses that do not declare an image media type before
reading the downloaded temporary file into app memory.

## Priority

1. Keep non-image response bodies out of the image publication path.
2. Validate response metadata before temporary-file attributes or bytes are
   read.
3. Preserve existing HTTPS, status, size, lifecycle, and decode boundaries.

## Requirements

- R1. `ImageLoader` must require a present `Content-Type` whose normalized media
  type starts with `image/`.
- R2. Media-type parsing must ignore parameters and surrounding whitespace and
  compare case-insensitively.
- R3. The media-type guard must run after the 2xx status check and before file
  attributes, file size, or `Data(contentsOf:)` are read.
- R4. Missing, empty, malformed, HTML, JSON, and other non-image media types
  must fail closed without publishing data or logging response content.
- R5. Existing URL validation, task retention/cancellation, weak capture,
  declared and actual 5 MiB limits, empty-body guard, and main-thread
  publication must remain unchanged.
- R6. Static contracts must reject helper removal, non-image allowlisting,
  guard-after-file-read ordering, and weakened documentation or plan evidence.
- R7. README, SECURITY, VISION, CHANGES, and AGENTS must document the boundary
  without claiming Swift compilation, device behavior, or live CDN validation.

## Non-Goals

- Sniffing file signatures, decoding image formats inside `ImageLoader`, or
  restricting the accepted image subtype set.
- Changing image URLs, request headers, caching, timeout behavior, payload size,
  SwiftUI rendering, or fallback UI.
- Upgrading Swift, Xcode, iOS, URLSession behavior, or project dependencies.
- Making live Foursquare or CDN requests.

## Implementation Units

### 1. Image Media-Type Helper

Files: `FSQNearby/Service/ImageLoader.swift`

- Add a small `HTTPURLResponse` helper that normalizes `Content-Type` and
  accepts only `image/*` media types.
- Invoke it before accessing the downloaded file.

### 2. Static Contract

Files: `scripts/check-baseline.sh`

- Require the helper, exact `image/` policy, one guard call, and metadata-before-
  file-read ordering.

### 3. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`, `AGENTS.md`

- Record the image response media-type boundary and continuing runtime limits.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Remove the helper, allow HTML, and move the guard after file reads; the static
  gate must reject each mutation.
- Run shell syntax, plist/workspace parsing, executable-mode verification,
  `git diff --check`, and intended-path artifact and secret scans.
- Take bounded exact-head push, pull-request, and code-scanning snapshots after
  push; do not start a polling or watch loop.

## Work Completed

- Added `isImageResponse` to normalize the declared media type by removing
  parameters, trimming whitespace, and lowercasing it.
- Required a nonempty `image/*` media type after the 2xx status guard and before
  temporary-file metadata or bytes are read.
- Preserved URL validation, task lifecycle, weak capture, declared and actual
  5 MiB limits, empty-body rejection, and main-thread publication.
- Added static source, ordering, documentation, and completed-plan contracts.

## Verification Completed

- The media-type helper mutation failed after renaming the required helper.
- The HTML allowlist mutation failed after replacing the image policy with
  `text/html`.
- The late validation mutation failed after moving the media-type guard below
  `Data(contentsOf:)`.
- `make check`, `make lint`, `make test`, and `make build` passed the maintained
  static baseline; each correctly reported that local `xcodebuild` is
  unavailable.
- `sh -n scripts/check-baseline.sh`, Info.plist and workspace XML parsing,
  executable-mode verification, and `git diff --check` passed.
- Intended-path artifact and secret scans found no generated files or embedded
  credentials.
- The hosted pull-request check and code-scanning results are recorded against
  the exact pushed head in the external engineering tracker. Embedding that SHA
  here would create a new head without exact-head hosted evidence.
