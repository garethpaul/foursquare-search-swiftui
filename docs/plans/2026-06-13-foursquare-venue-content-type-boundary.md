---
title: Foursquare Venue Content-Type Boundary
date: 2026-06-13
status: in_progress
execution: code
---

## Context

Venue downloads reject non-2xx, empty, and oversized responses before JSON
decoding, but they do not verify that the server identified the payload as
JSON. A misconfigured endpoint can therefore make the app read and attempt to
decode HTML or another response type within the 2 MiB limit.

## Goals

- Require an explicit JSON media type before reading the downloaded file.
- Accept `application/json` and structured `application/*+json` media types
  with optional parameters and case-insensitive matching.
- Preserve the existing URL validation, task cancellation, status, size,
  decoding, and user-visible error boundaries.
- Add a static contract that rejects missing, weakened, or late media-type
  validation.

## Implementation

- Add a small `HTTPURLResponse` media-type helper in `VenueFetcher`.
- Gate file metadata and `Data(contentsOf:)` behind the JSON response check.
- Extend the baseline checker and repository guidance to preserve the boundary.
- Record completed local and hosted verification evidence in this plan.

## Verification Plan

- Run `sh -n scripts/check-baseline.sh`, all four Make gates, plist/workspace
  parsing, `git diff --check`, and an intended-file secret scan.
- Remove the media-type guard, weaken it to accept HTML, and move it after the
  file read; each hostile mutation must fail the maintained gate.
- Take one bounded exact-head pull-request and CodeQL snapshot after push; do
  not poll.
