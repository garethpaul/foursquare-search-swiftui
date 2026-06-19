---
title: Foursquare Image Redirect Refusal
date: 2026-06-15
status: completed
execution: static-contract
---

# Foursquare Image Redirect Refusal

## Problem Frame

`ImageLoader` validates an exact final response URL, but its default
`URLSession` follows redirects before that validation runs. An image URL from a
venue response can therefore trigger a second request and download from an
unreviewed redirect target before the body is discarded.

## Prioritized Engineering Work

1. **P0 - Request provenance:** refuse image HTTP redirects before a second
   request is sent.
2. **P1 - Lifecycle preservation:** retain the redirect delegate with the
   loader-owned session and preserve cancellation and invalidation ordering.
3. **P2 - Maintained contract:** add mutation-sensitive source, plan, and
   guidance checks without claiming unavailable Apple runtime execution.

## Requirements

- Add one private image-specific `URLSessionTaskDelegate` that passes `nil` to
  every HTTP redirection completion handler.
- Retain the delegate and construct the existing bounded image session with it.
- Keep exactly one image download task and preserve exact final URL, 2xx,
  image media type, declared/file/decoded size, non-empty, weak-capture,
  cancellation, and main-queue publication behavior.
- Keep venue networking and its redirect delegate unchanged.
- Static contracts must reject delegate removal, redirect acceptance, default
  session fallback, duplicate requests, final URL guard loss, guidance drift,
  and incomplete plan evidence.

## Implementation Units

### Refuse Image Redirects

Files:

- `FSQNearby/Service/ImageLoader.swift`

Approach:

- Mirror the existing venue redirect-refusal pattern with a distinct private
  delegate type.
- Retain the delegate beside the loader-owned session and pass it during
  bounded session construction.

### Enforce And Document The Boundary

Files:

- `scripts/check-baseline.sh`
- `AGENTS.md`
- `CHANGES.md`
- `README.md`
- `SECURITY.md`
- `VISION.md`
- `docs/plans/2026-06-15-foursquare-image-redirect-refusal.md`

## Verification

- All repository Make gates and the absolute-Makefile check from an external
  directory.
- Hostile mutations for delegate removal, redirect acceptance, delegate
  retention, default-session fallback, duplicate requests, final URL guard,
  guidance, and plan completion evidence.
- Shell syntax, project/plist parsing, exact diff, generated artifact,
  protected binary, mode, and changed-line credential audits.

## Scope Boundaries

- Do not change image URL acceptance, rendering, caching, payload limits,
  venue networking, dependencies, or Xcode project metadata.
- Do not claim Xcode, simulator/device, signing, or live CDN validation from
  this Linux host.

## Work Completed

- Added a retained image-specific `URLSessionTaskDelegate` that refuses every
  HTTP redirect by passing `nil` to the completion handler.
- Constructed the bounded image session with the retained delegate while
  preserving one download task and cancellation-before-invalidation teardown.
- Preserved exact final URL, 2xx, image media type, declared/file/decoded size,
  non-empty, weak-capture, and main-queue publication guards.
- Added static, timeout-ordering, guidance, mutation, and completed-plan
  contracts.

## Verification Completed

- All four Make gates and the absolute-Makefile check passed; each reported
  that `xcodebuild` is unavailable on this Linux host rather than claiming an
  Apple-platform build.
- The delegate removal mutation failed the retained redirect-policy contract.
- The redirect acceptance mutation failed after forwarding the new request.
- The delegate retention mutation failed after removing loader ownership.
- The default session mutation failed the delegate-backed timeout contract.
- The duplicate request mutation failed the existing single-task lifecycle
  contract.
- The final URL guard mutation failed the exact response provenance contract.
- The guidance mutation failed the maintained redirect-refusal contract.
- The plan evidence mutation failed the completed-evidence contract.
- Shell syntax, checker compilation, `git diff --check`, artifact, protected
  binary, mode, and changed-line credential audits passed before delivery.
- No live image request, CDN redirect, simulator, device, or signed build was
  exercised.

## Status: Completed
