# Foursquare SwiftUI Image Size Boundary

status: completed

## Context

`ImageLoader` validates remote image URL parts, response status, nonempty data,
and image decodability, but it accepts response bodies of any size. A malformed
or unexpectedly large image can consume excessive memory before SwiftUI renders
the venue icon.

## Priority

This is the highest-value remaining bounded change because image URLs are
remote response data and image decoding expands compressed input in memory. The
existing lifecycle and transport guards do not limit that resource exposure.

## Implementation

- Define a 5 MiB maximum accepted image payload.
- Download to a temporary file so an untrusted body is not buffered into app
  memory before its actual size can be checked.
- Reject a positive `expectedContentLength` above the limit before publishing.
- Reject the temporary file above the limit even when length metadata is absent
  or inaccurate, then load only the bounded file into `Data`.
- Preserve current HTTPS, response status, nonempty-data, weak-capture, and task
  cancellation behavior.
- Extend the static baseline and project documentation.

## Verification

- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
- Mutations removing either metadata or actual-byte enforcement must fail.
- Hosted macOS `make check` and Xcode project parsing.
