---
title: Foursquare Envelope Status Validation
type: security
status: planned
date: 2026-06-17
---

# Foursquare Envelope Status Validation

## Context

Venue transport validation requires a successful HTTP response, but decoded
Foursquare payloads are published without checking `meta.code` or requiring a
`response` object. An API error envelope can therefore be presented as an
ordinary empty result.

## Requirements

- Add a Foundation-only production policy that accepts only decoded envelopes
  with `meta.code == 200` and a present response object.
- Apply the policy after JSON decoding and before publishing venue state.
- Preserve valid empty venue arrays as the existing "No venues found" state.
- Add standalone Swift behavior tests for accepted, missing, non-200, and
  response-absent cases using the actual production helper.
- Wire the harness into `make check` and maintained hosted validation without
  credentials or live network requests.
- Add mutation-sensitive static contracts and maintained guidance.

## Implementation Units

### 1. Production envelope policy

Files:

- `FSQNearby/Service/FoursquareEnvelopePolicy.swift`
- `FSQNearby/Service/VenueFetcher.swift`
- `FSQNearby.xcodeproj/project.pbxproj`

Keep transport validation and decoded-envelope validation separate, and route
rejected envelopes through the existing generic error publication path.

### 2. Executable and static regressions

Files:

- `Tests/FoursquareEnvelopePolicyTests/main.swift`
- `scripts/run-foursquare-envelope-policy-tests.sh`
- `scripts/check-baseline.sh`
- `Makefile`

Compile the production helper directly with a credential-free standalone
harness on macOS and retain portable static checks on Linux.

### 3. Guidance and evidence

Files:

- `README.md`
- `SECURITY.md`
- `VISION.md`
- `CHANGES.md`
- `AGENTS.md`
- `docs/plans/2026-06-17-foursquare-envelope-status.md`

Document the decoded status boundary and record only validation that actually
ran.

## Validation

- Run the standalone Swift behavior tests where `swiftc` is available.
- Run repository-root and external-directory `make check`.
- Reject isolated mutations for policy status, response presence, production
  delegation, behavior cases, project/Make wiring, guidance, and plan status.
- Audit project membership, exact diff, generated artifacts, whitespace,
  conflict markers, and credential-shaped additions.
- Require exact-head hosted checks before recording terminal hosted evidence.

## Scope Boundaries

- Do not reject a valid response merely because its venue array is empty.
- Do not log raw response bodies, request URLs, or credentials.
- Do not make a live Foursquare request or change transport-level boundaries.
- Do not merge or close this stacked pull request or its predecessors without
  explicit authorization.

## Verification Results

Implementation and verification are pending.
