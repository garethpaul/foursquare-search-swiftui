---
title: Foursquare Venue Redirect Refusal
date: 2026-06-15
status: completed
execution: static-contract
---

# Foursquare Venue Redirect Refusal

## Context

`VenueFetcher` uses a locally configured HTTPS URL that may contain private
query data. Its exact final URL guard rejects redirected responses only after
`URLSession.shared` has already followed the redirect and sent a second request.

## Requirements

- Use one dedicated default `URLSession` with a retained task delegate.
- Have the delegate refuse every HTTP redirect by calling the completion
  handler with `nil`.
- Route only the venue download through the dedicated session.
- Preserve task cancellation, response-size limits, exact final URL, status,
  JSON media validation, generic errors, and main-thread publication.
- Add mutation-sensitive static contracts and maintained repository guidance.
- Record actual local and mutation verification without claiming unavailable
  Xcode, simulator, device, or live Foursquare execution.

## Non-Goals

- Changing venue URL configuration, query parameters, credentials, schemas,
  payload limits, UI states, image loading, or dependency/platform versions.
- Broadly disabling redirects for unrelated URLSession traffic.
- Modernizing Swift, SwiftUI, Xcode project metadata, or the Foursquare API.

## Implementation

1. Add a private `URLSessionTaskDelegate` that refuses redirects.
2. Retain the delegate and a dedicated default session in `VenueFetcher`.
3. Issue the existing single download through that session.
4. Extend `scripts/check-baseline.sh` and maintained guidance.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` from the root.
- Run the absolute Makefile `check` target from an external directory.
- Reject delegate removal, redirect acceptance, shared-session fallback,
  request duplication, final URL guard removal, and plan evidence drift.
- Run shell syntax, diff, artifact, mode, and intended-file secret audits.
- Capture one bounded exact-head hosted snapshot after push.

## Work Completed

- Added a retained private `URLSessionTaskDelegate` that refuses every venue
  redirect by calling the completion handler with `nil`.
- Added a dedicated default venue session, routed the existing single download
  through it, and invalidated it with the retained task during teardown.
- Preserved exact final URL, status, JSON media, size, file, decoding, error,
  and main-thread publication behavior.
- Extended static contracts and maintained repository guidance.

## Verification Completed

- All four Make gates passed in an isolated copy of the exact source tree, and
  the absolute-Makefile check passed from an external directory.
- The delegate removal mutation failed the retained redirect-policy contract.
- The redirect acceptance mutation failed after forwarding the new request.
- The shared session mutation failed after bypassing the dedicated session.
- The duplicate request mutation failed the single-download contract.
- The final URL guard mutation failed the response-provenance contract.
- The plan evidence mutation failed the completed-evidence contract.
- Shell syntax and `git diff --check` passed before final-tree verification.
- `xcodebuild`, simulator/device execution, signing, and live Foursquare
  behavior are unavailable or intentionally excluded on this Linux host.
- The hosted pull-request check is captured after push and recorded in the
  exact-head tracker evidence rather than claimed by this pre-push plan.
