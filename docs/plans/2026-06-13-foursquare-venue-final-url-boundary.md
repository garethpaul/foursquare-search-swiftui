---
title: Foursquare Venue Final URL Boundary
type: security
status: completed
date: 2026-06-13
---

# Foursquare Venue Final URL Boundary

## Summary

Reject venue responses whose final URL differs from the validated configured
request URL before response metadata, temporary files, or JSON are consumed.

## Priority

1. Preserve the credentialed venue response provenance boundary across redirects.
2. Validate the final URL before media, length, file, and decode work.
3. Preserve existing status, media, payload-size, lifecycle, and error behavior.

## Requirements

- R1. The venue response guard must require `httpResponse.url == url`.
- R2. Final URL equality must be checked after the HTTP response cast and before
  status, media-type, declared-length, file metadata, file read, or JSON decode.
- R3. Redirected or otherwise mismatched responses must use the existing generic
  no-data error without logging the request or final URL.
- R4. Static contracts must reject guard removal, permissive host-only matching,
  validation reordering, duplicate request creation, error weakening,
  documentation drift, or incomplete plan evidence.
- R5. README, SECURITY, VISION, CHANGES, and AGENTS must describe the exact final
  URL boundary without claiming redirect prevention or live API validation.
- R6. The completed plan must record actual local, mutation, and hosted evidence.

## Non-Goals

- Preventing URLSession from making the redirected network request.
- Adding a custom URLSession delegate or redirect callback.
- Changing the configured URL, query parameters, credentials, status/media
  allowlists, payload limits, JSON schema, or UI behavior.
- Changing image redirect behavior.
- Claiming Swift compilation, simulator/device, or live Foursquare validation.

## Implementation Units

### 1. Final URL Guard

Files: `FSQNearby/Service/VenueFetcher.swift`

- Require exact final/request URL equality before all response processing.

### 2. Static Contracts

Files: `scripts/check-baseline.sh`

- Require the exact guard, ordering, single request, generic error, docs, and
  completed evidence.

### 3. Repository Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`, `AGENTS.md`

- Record provenance validation and its distinction from redirect prevention.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Remove the guard, reduce it to host comparison, move it after file reads,
  duplicate the request, weaken the generic error, and regress plan evidence;
  each mutation must be rejected.
- Run shell syntax, plist/workspace XML parsing, executable-mode verification,
  `git diff --check`, and intended-file secret/artifact scans.
- Take bounded exact-head push, pull-request, and code-scanning snapshots after
  push; do not start a watch loop.

## Work Completed

- Added exact final/request URL equality to the venue response guard before
  status, media, length, file, or decode processing.
- Preserved the existing generic no-data error for provenance rejection without
  logging configured or final URLs.
- Extended the structural checker and repository guidance for exact provenance,
  ordering, single-request, generic-error, and completed-evidence contracts.

## Verification Completed

- All four Make gates passed the maintained static baseline.
- The guard removal mutation failed the exact provenance contract.
- The host-only mutation failed because exact URL equality is required.
- The validation ordering mutation failed after moving the valid guard below
  status and media validation.
- The duplicate request mutation failed the single-download contract.
- The error weakening mutation failed the generic no-data error contract.
- The plan evidence mutation failed the completed-evidence contract.
- Shell syntax, plist/workspace XML parsing, executable-mode verification,
  `git diff --check`, and intended-file secret and artifact scans are included
  in final-tree verification.
- `xcodebuild`, Swift compilation, simulator/device execution, and live
  Foursquare redirect behavior are unavailable or intentionally unclaimed on
  this Linux host.
- The hosted pull-request check and code-scanning snapshot will be recorded
  against the exact pushed head in the external engineering tracker.
