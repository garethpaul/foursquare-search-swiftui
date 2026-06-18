---
title: Foursquare Swift Runner Signal Cleanup
type: bugfix
status: completed
date: 2026-06-18
execution: code
---

# Foursquare Swift Runner Signal Cleanup

## Status

Completed. The runner changes, local validation, mutation checks, and exact
implementation-head hosted verification are complete.

## Context

The envelope-policy and venue-text Swift runners create unique temporary build
directories and remove them through an exit trap. Their HUP, INT, and TERM
handlers call `exit` directly, however, and POSIX `sh` does not guarantee that
the exit trap runs when `exit` is invoked from another trap.

Bounded process-group probes reproduced the failure for both runners: each
returned status 143 after TERM and left its newly created build directory in
`/tmp`. The leaked paths were removed explicitly after the probes.

## Plan

- Give both runners a signal handler that disables all traps, removes the
  temporary build directory, and exits with the conventional signal status.
- Preserve existing success cleanup and compiler or test failure propagation.
- Extend the baseline checker with structured contracts for the handler body
  and all HUP, INT, and TERM bindings in both runners.
- Exercise success, compiler failure, and bounded TERM cleanup independently
  for each runner with fake compilers.
- Reject isolated mutations that remove cleanup or restore an exit-only signal
  binding.
- Run every maintained Make alias from the repository and `make check` through
  the absolute Makefile path from an external directory.
- Audit the exact diff, executable modes, generated artifacts, whitespace, and
  credential-shaped additions before committing only intended paths.
- Record exact implementation and completed-plan heads plus canonical push and
  pull-request checks before marking this plan completed.

## Risks

- Signal handling differs among shells, so the implementation must remain
  limited to POSIX syntax used by `/bin/sh` on Linux and macOS.
- Linux cannot compile or run the Swift application in this environment;
  canonical macOS checks remain authoritative for executable Swift coverage.
- The pull request is stacked on the venue-name boundary and must retain its
  intended base ordering.

## Verification Completed

- `sh -n` passed for the baseline checker and both runners.
- Focused fake compilers proved success cleanup, compiler status 42
  propagation, and TERM status 143 without a leaked build directory for both
  runners.
- `make check`, `make lint`, `make test`, and `make build` passed from the
  repository. Absolute-Makefile `make check` also passed from `/tmp`.
- Isolated mutations removing direct cleanup, restoring an exit-only TERM
  binding, and completing this plan before hosted evidence were rejected.
- Exact diff, executable-mode, generated-artifact, whitespace, and
  credential-shaped addition audits passed.
- Exact implementation head `7fe403ad832c8b4124a61741462bb89970d5b4f7`
  passed push run `27747867228` and pull-request run `27747868221` on macOS.
  Both canonical runs exercised the production Swift harnesses and completed
  successfully.
- Linux could not run Swift or Xcode, and no live Foursquare request,
  simulator interaction, or physical-device behavior was exercised.
