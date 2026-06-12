# Changes

## 2026-06-12

- Stopped GitHub Actions checkout credential persistence and added an exact
  contract for the single pinned checkout step.
- Bounded accepted Foursquare venue search JSON to 2 MiB using a temporary-file
  download, response length metadata, and actual file size before decoding.
- Routed empty and oversized venue bodies through the existing visible error
  state and added a static transport contract.

## 2026-06-10

- Bounded accepted remote image payloads to 5 MiB using response length
  metadata and actual downloaded byte count.
- Added a GitHub Actions workflow that runs the existing `make check` baseline
  on pushes, pull requests, and manual dispatches.
- Hardened the workflow with pinned actions, read-only permissions, bounded
  execution, and a macOS Xcode project parse before review.
- Added a static guard requiring the CI workflow and completed CI baseline plan
  to remain checked in.

## 2026-06-09

- Ignored undecodable image payloads before replacing SwiftUI icon state.
- Ignored empty image response bodies before publishing SwiftUI image data.
- Rejected image URL userinfo and fragments before starting image requests.
- Added `make lint`, `make test`, and `make build` aliases so local verification
  has the expected pre-push gate targets in addition to `make check`.
- Aligned image URLSession callbacks with the loader lifecycle by capturing the
  loader weakly before publishing downloaded image data.
- Rejected venue-search endpoint userinfo and fragments before starting
  requests.

## 2026-06-08

- Retained and cancelled venue search URLSession tasks when fetchers are
  deallocated.
- Removed the global App Transport Security arbitrary-loads bypass.
- Moved the Foursquare venue-search endpoint to a local build setting.
- Required HTTPS for venue and image loading.
- Removed runtime `print` diagnostics from network loading.
- Added empty/error venue states and safer optional rendering in SwiftUI views.
- Stopped image loading from recursively refetching after data changes.
- Required venue and image request URLs to include an HTTPS host.
- Retained image URLSession tasks and cancelled them when image loaders are
  deallocated.
- Added `make check` and `scripts/check-baseline.sh` for static transport and
  configuration verification.
