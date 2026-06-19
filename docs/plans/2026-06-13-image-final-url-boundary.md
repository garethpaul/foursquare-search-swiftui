---
title: Image Final URL Boundary
type: security
status: completed
date: 2026-06-13
---

# Image Final URL Boundary

## Summary

Reject remote image download responses whose final URL differs from the exact
validated HTTPS request URL before reading the downloaded file.

## Requirements

- R1. Require `httpResponse.url == url` before status, media, size, file, or
  body acceptance.
- R2. Preserve URL shape, 2xx, image media type, 5 MiB, non-empty, cancellation,
  and main-queue publication behavior.
- R3. Add ordering, uniqueness, documentation, completion, and mutation
  contracts.
- R4. Do not claim that the request was prevented from following redirects.
- R5. Do not claim live CDN, simulator, or device validation.

## Verification Plan

- Run all four Make gates and shell/diff/project metadata checks.
- Reject guard removal, host-only validation, ordering drift, stale plan, and
  missing evidence mutations.
- Take one bounded exact-head push/PR/code-scanning snapshot after push.

## Non-Goals

- Installing a custom URLSession redirect delegate.
- Changing image decoding, caching, rendering, or payload limits.
- Changing venue search, project metadata, dependencies, or CI.

## Work Completed

- Required the final HTTP response URL to equal the validated image request URL.
- Kept provenance validation ahead of status, media, size, temporary-file, and
  data processing.
- Added static, documentation, completion, and mutation contracts.

## Verification Completed

- The five hostile mutations were rejected: guard removal, host-only matching,
  validation ordering drift, stale plan status, and missing evidence.
- The all four Make gates passed result was confirmed against the final tree.
- Shell syntax, plist/workspace parsing, `git diff --check`, artifact, protected
  path, and secret scans are included in final verification.
- `xcodebuild was unavailable` on this Linux host, so no Swift build, simulator,
  or device execution was attempted.
- No live image request or CDN redirect was exercised; redirect prevention is
  not claimed.
