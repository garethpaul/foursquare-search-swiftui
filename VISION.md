## Foursquare Search SwiftUI Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Foursquare Search SwiftUI is a SwiftUI tutorial app that lists nearby venues
from a Foursquare search response.

The repository is useful as a compact SwiftUI sample with venue models,
category/icon views, image loading, and a network-backed venue list. Project
context lives in [`README.md`](README.md).

The goal is to keep the tutorial clear and runnable while making API
configuration, location assumptions, and generated model code explicit.

The current focus is:

Priority:

- Preserve the SwiftUI venue list and detail components
- Keep Foursquare response models easy to inspect
- Avoid committing real API URLs, tokens, or user location data
- Keep screenshot and README aligned with app behavior

Current baseline:

- `scripts/check-baseline.sh`, `make lint`, `make test`, `make build`, and
  `make check` verify App Transport Security, HTTPS-only venue and image loading with URL hosts,
  local endpoint configuration, and runtime diagnostic guardrails.
- `FoursquareVenueSearchURL` is wired to the local
  `FOURSQUARE_VENUE_SEARCH_URL` build setting.
- Venue endpoint parsing rejects embedded userinfo and fragments while keeping
  HTTPS host validation.
- Image URL parsing rejects embedded userinfo and fragments while keeping HTTPS
  host validation.
- The global `NSAllowsArbitraryLoads` bypass has been removed.
- Venue decoding avoids force-unwrapping missing response data.
- Venue list loading now has visible empty/error states and optional-safe
  category/address rendering.
- Image loading retains and cancels URLSession tasks when loaders are released.
- Empty image response bodies are ignored before image data is published.
- Remote image responses require an explicit `image/*` media type before
  temporary-file reads.
- Remote image payloads use temporary-file downloads and are bounded to 5 MiB
  by response metadata and actual file size before entering app memory.
- Venue search payloads use temporary-file downloads and are bounded to 2 MiB
  by response metadata and actual file size before decoding; explicit JSON media types
  are required before file reads, and empty responses remain
  visible error states.
- The exact final venue response URL must match the configured request before
  response metadata or files are consumed.
- Undecodable image payloads are ignored before SwiftUI icon state is replaced.
- Image loading uses weak task captures before publishing downloaded data.
- Venue loading retains and cancels its URLSession task when fetchers are
  released.
- The local Makefile exposes lint, test, build, and check targets for a stable
  pre-push gate.
- GitHub Actions runs the static `make check` baseline on macOS before review,
  including the credential-free Xcode project parse.

Next priorities:

- Modernize SwiftUI and project settings in a dedicated pass
- Add tests or manual verification notes for decoded venue responses
- Keep image request lifecycle behavior visible as the view layer evolves
- Keep empty image response handling visible as image loading evolves
- Keep image media-type validation ahead of temporary-file reads
- Keep exact final venue response URL validation ahead of all response processing
- Keep undecodable image payload handling visible as icon rendering evolves
- Keep weak task captures visible as image loading evolves
- Keep venue request lifecycle behavior visible as data loading evolves
- Keep venue JSON response sizes bounded before decoding
- Keep venue endpoint URL-part validation visible as configuration evolves
- Keep image URL-part validation visible as remote image handling evolves
- Keep local verification targets available even while full Xcode testing needs
  a macOS toolchain

Contribution rules:

- One PR = one focused SwiftUI, API, model, or documentation change.
- Keep generated API models reviewable when response shapes change.
- Verify the venue list on simulator or device for UI changes.
- Keep credentials and private endpoints out of git.
- Keep `.github/workflows/check.yml` aligned with the static transport and
  Xcode project parsing baseline.

## Security And Privacy

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

Venue search can expose location intent. Do not commit real API credentials,
private endpoints, or user-specific location data.

Network code should use HTTPS URLs with hosts and make failure behavior visible.

## What We Will Not Merge (For Now)

- Hardcoded real Foursquare credentials or private proxy URLs
- Location tracking beyond the tutorial's explicit lookup flow
- Model regeneration without response-shape notes
- SwiftUI redesigns that obscure the tutorial purpose

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
