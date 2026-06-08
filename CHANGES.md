# Changes

## 2026-06-08

- Removed the global App Transport Security arbitrary-loads bypass.
- Moved the Foursquare venue-search endpoint to a local build setting.
- Required HTTPS for venue and image loading.
- Removed runtime `print` diagnostics from network loading.
- Added empty/error venue states and safer optional rendering in SwiftUI views.
- Stopped image loading from recursively refetching after data changes.
- Added `make check` and `scripts/check-baseline.sh` for static transport and
  configuration verification.
