---
title: Foursquare Image Redirect Refusal
date: 2026-06-15
status: in_progress
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

## Work Pending

- Implement the retained image redirect-refusal delegate.
- Add contracts, synchronized guidance, and actual verification evidence.
