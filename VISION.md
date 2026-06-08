## Foursquare Search SwiftUI Vision

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

Next priorities:

- Document how to configure the Foursquare venue-search URL securely
- Add error and empty-state handling for network failures
- Modernize SwiftUI and project settings in a dedicated pass
- Add tests or manual verification notes for decoded venue responses

Contribution rules:

- One PR = one focused SwiftUI, API, model, or documentation change.
- Keep generated API models reviewable when response shapes change.
- Verify the venue list on simulator or device for UI changes.
- Keep credentials and private endpoints out of git.

## Security And Privacy

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

Venue search can expose location intent. Do not commit real API credentials,
private endpoints, or user-specific location data.

Network code should use HTTPS and make failure behavior visible.

## What We Will Not Merge (For Now)

- Hardcoded real Foursquare credentials or private proxy URLs
- Location tracking beyond the tutorial's explicit lookup flow
- Model regeneration without response-shape notes
- SwiftUI redesigns that obscure the tutorial purpose

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
