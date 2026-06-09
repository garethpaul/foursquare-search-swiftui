# Changes

## 2026-06-09

- Aligned image URLSession callbacks with the loader lifecycle by capturing the
  loader weakly before publishing downloaded image data.

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
