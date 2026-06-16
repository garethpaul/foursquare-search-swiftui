---
title: Hosted SwiftUI Simulator Build
type: reliability
date: 2026-06-16
status: completed
execution: code
---

# Hosted SwiftUI Simulator Build

## Context

The canonical macOS gate parses the Xcode project but never compiles its
thirteen Swift sources. This leaves source compatibility unproven despite an
available hosted Apple toolchain.

## Requirements

- Compile the `FSQNearby` target for the iOS simulator whenever `xcodebuild` is
  available.
- Disable signing and isolate build products and intermediates in a temporary
  directory that is removed on success or failure.
- Preserve the portable static gate and explicit Linux skip.
- Add fail-closed workflow, command-order, cleanup, documentation, and plan
  contracts.

## Verification

- Repository and external-directory `make check` on Linux.
- Static mutations for command removal, target drift, signing drift, temporary
  cleanup removal, workflow bypass, guidance, and plan evidence.
- Exact-head hosted push and pull-request builds on macOS 15.
- Artifact, credential-pattern, exact-diff, and whitespace audits.

## Scope Boundary

No source, deployment target, signing identity, project setting, network
behavior, simulator interaction, or device behavior changes in this patch.

## Verification Results

- The repository and external-directory make check passed all portable static
  contracts; xcodebuild is unavailable on Linux, so no local Swift compilation
  is claimed.
- Seven hostile hosted-build mutations were rejected across command presence,
  target, simulator SDK, signing, temporary cleanup, workflow wiring, and plan
  evidence.
- Exact-diff, generated-artifact, credential-pattern, and whitespace audits
  passed.
- Exact-head hosted push and pull-request builds are required before closure.
