# AGENTS.md

## Repository purpose

`garethpaul/foursquare-search-swiftui` is an Apple platform application or Objective-C/Swift sample. List Nearby Venues with SwiftUI

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `FSQNearby.xcodeproj` - Xcode project
- `FSQNearby` - repository source or sample assets
- `images` - repository source or sample assets

## Development commands

- Install dependencies: no repository-specific install command is documented.
- Full baseline: `make check`
- Local Apple development: `open FSQNearby.xcodeproj`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: Swift app sources with focused Swift policy harnesses.
- Preserve legacy Xcode project settings and signing assumptions unless the change is explicitly about modernization.

## Testing guidance

- Focused Swift policy harnesses live under `Tests/`; treat `make check` as the minimum baseline.
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- `FOURSQUARE_VENUE_SEARCH_URL` supplies the venue-search endpoint.
- Keep API credentials, private endpoints, query URLs with location data, `.xcconfig` files, and `.env` files out of source control.
- Missing configuration, empty responses, and network failures should render a visible state instead of crashing or leaving a blank list.
- Hosted simulator builds compile all fifteen Swift sources with signing disabled.
- Venue and image URLSession tasks should stay tied to their observable object lifecycles.
- Keep the venue fetcher owned by the hosted SwiftUI root and injected into
  `VenueListView`; child reconstruction must not start duplicate requests.
- SwiftUI venue and image networking use 15-second request timeouts and 30-second resource timeouts.
- Image URLSession callbacks should use weak task captures before publishing downloaded data.
- Image URL userinfo and fragments should be rejected before starting requests.
- Remote image responses should require an `image/*` Content-Type before
  temporary-file metadata or bytes are read.
- Keep exact final image response URL validation ahead of status, media, size,
  file, and decode processing, and keep the dedicated image session configured
  to refuse redirects before an unreviewed target can receive a second request.
- Keep exact final venue response URL validation ahead of status, media, size,
  file, and decode processing, and keep the dedicated venue session configured
  to refuse redirects before private query data can be forwarded.
- Require decoded Foursquare meta code 200 before publishing venue state, and
  require a present response object.
- Reject blank decoded venue names before publishing, and render accepted names
  through the production normalization policy.
- Check icon image metadata before UIKit decode and reject images above 4,096
  pixels per side or 4,000,000 decoded pixels.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
