#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-foursquare-search-swiftui-transport-baseline.md"
HOST_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-swiftui-url-host-validation.md"
IMAGE_TASK_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-swiftui-image-task-lifecycle.md"
VENUE_TASK_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-swiftui-venue-task-lifecycle.md"
IMAGE_CAPTURE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-swiftui-image-weak-capture.md"
VENUE_URL_PARTS_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-swiftui-venue-url-parts.md"
MAKE_GATES_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-swiftui-make-gate-aliases.md"
IMAGE_URL_PARTS_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-swiftui-image-url-parts.md"
IMAGE_EMPTY_DATA_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-swiftui-image-empty-data.md"
IMAGE_DECODE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-foursquare-swiftui-image-decode-guard.md"
IMAGE_SIZE_PLAN="$ROOT_DIR/docs/plans/2026-06-10-foursquare-swiftui-image-size-boundary.md"
VENUE_SIZE_PLAN="$ROOT_DIR/docs/plans/2026-06-12-foursquare-venue-response-size-boundary.md"
VENUE_CONTENT_TYPE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-foursquare-venue-content-type-boundary.md"
IMAGE_CONTENT_TYPE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-foursquare-image-content-type-boundary.md"
VENUE_FINAL_URL_PLAN="$ROOT_DIR/docs/plans/2026-06-13-foursquare-venue-final-url-boundary.md"
IMAGE_FINAL_URL_PLAN="$ROOT_DIR/docs/plans/2026-06-13-image-final-url-boundary.md"
LOCATION_INDEPENDENT_MAKE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-location-independent-make.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-ci-baseline.md"
CHECKOUT_CREDENTIAL_PLAN="$ROOT_DIR/docs/plans/2026-06-12-checkout-credential-boundary.md"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "FSQNearby.xcodeproj/project.pbxproj" \
  "FSQNearby/Info.plist" \
  "FSQNearby/Service/VenueFetcher.swift" \
  "FSQNearby/Service/ImageLoader.swift" \
  "FSQNearby/View/AddressView.swift" \
  "FSQNearby/View/CategoryIconView.swift" \
  "FSQNearby/View/CategoryView.swift" \
  "FSQNearby/View/IconView.swift" \
  "FSQNearby/View/VenueListView.swift" \
  "docs/bugs/p2-ios-global-ats-bypass-d3b1b3edbda3cef9.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-venue-task-lifecycle.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-empty-data.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-decode-guard.md" \
  "docs/plans/2026-06-10-foursquare-swiftui-image-size-boundary.md" \
  "docs/plans/2026-06-12-foursquare-venue-response-size-boundary.md" \
  "docs/plans/2026-06-13-foursquare-venue-content-type-boundary.md" \
  "docs/plans/2026-06-13-foursquare-image-content-type-boundary.md" \
  "docs/plans/2026-06-13-foursquare-venue-final-url-boundary.md" \
  "docs/plans/2026-06-13-image-final-url-boundary.md" \
  "docs/plans/2026-06-13-location-independent-make.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-url-parts.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-venue-url-parts.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-make-gate-aliases.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-weak-capture.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-task-lifecycle.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-url-host-validation.md" \
  "docs/plans/2026-06-10-ci-baseline.md" \
  "docs/plans/2026-06-12-checkout-credential-boundary.md" \
  ".github/workflows/check.yml" \
  "docs/plans/2026-06-08-foursquare-search-swiftui-transport-baseline.md"; do
  require_file "$path"
done

if ! grep -Fq 'ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))' "$ROOT_DIR/Makefile" ||
  ! grep -Fq '"$(ROOT)/scripts/check-baseline.sh"' "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile verification must resolve the checker from the loaded Makefile." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "from /tmp" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "absolute Makefile path" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Made static verification independent" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Location-independent Make plan and guidance must record completed external verification." >&2
  exit 1
fi

makefile="$ROOT_DIR/Makefile"
if ! grep -Eq '^\.PHONY: .*build.*check.*lint.*test|^\.PHONY: .*build.*lint.*test.*check' "$makefile" ||
  ! grep -Fq "lint test build: check" "$makefile"; then
  printf '%s\n' "Makefile must expose lint, test, build, and check gate targets." >&2
  exit 1
fi

if command -v python3 >/dev/null 2>&1; then
  python3 - "$ROOT_DIR/FSQNearby/Info.plist" <<'PY'
import plistlib
import sys

with open(sys.argv[1], "rb") as plist_file:
    plist = plistlib.load(plist_file)

ats = plist.get("NSAppTransportSecurity", {})
if ats.get("NSAllowsArbitraryLoads") is True:
    raise SystemExit("NSAllowsArbitraryLoads must not be enabled")

if plist.get("FoursquareVenueSearchURL") != "$(FOURSQUARE_VENUE_SEARCH_URL)":
    raise SystemExit("FoursquareVenueSearchURL must use the local build setting")
PY
else
  printf '%s\n' "Skipping Info.plist parse: python3 is not installed."
fi

if grep -R -n "NSAllowsArbitraryLoads" "$ROOT_DIR/FSQNearby"; then
  printf '%s\n' "Global ATS arbitrary loads must not be present." >&2
  exit 1
fi

venue="$ROOT_DIR/FSQNearby/Service/VenueFetcher.swift"
if ! grep -Fq "venueSearchURL" "$venue" ||
  ! grep -Fq 'object(forInfoDictionaryKey: "FoursquareVenueSearchURL")' "$venue" ||
  ! grep -Fq 'url.scheme == "https"' "$venue" ||
  ! grep -Fq 'url.host?.isEmpty == false' "$venue" ||
  ! grep -Fq "url.user == nil" "$venue" ||
  ! grep -Fq "url.password == nil" "$venue" ||
  ! grep -Fq "url.fragment == nil" "$venue" ||
  ! grep -Fq 'errorMessage' "$venue" ||
  ! grep -Fq "private var task: URLSessionDownloadTask?" "$venue" ||
  ! grep -Fq "deinit" "$venue" ||
  ! grep -Fq "task?.cancel()" "$venue" ||
  ! grep -Fq "task?.resume()" "$venue" ||
  ! grep -Fq "private let maxVenuePayloadBytes = 2 * 1024 * 1024" "$venue" ||
  ! grep -Fq "httpResponse.expectedContentLength < 0" "$venue" ||
  ! grep -Fq "httpResponse.expectedContentLength <= Int64(self.maxVenuePayloadBytes)" "$venue" ||
  ! grep -Fq "let attributes = try? FileManager.default.attributesOfItem(atPath: location.path)" "$venue" ||
  ! grep -Fq "fileSize.intValue <= self.maxVenuePayloadBytes" "$venue" ||
  ! grep -Fq "let data = try? Data(contentsOf: location)" "$venue" ||
  ! grep -Fq "!data.isEmpty" "$venue" ||
  ! grep -Fq "data.count <= self.maxVenuePayloadBytes" "$venue" ||
  grep -Fq "URLSession.shared.dataTask" "$venue" ||
  grep -Fq 'URL(string: "FOURSQUARE_VENUE_SEARCH")!' "$venue" ||
  grep -Eq 'responseData\?\.(venues)\)!|URL\(string:.*\)!|print\(' "$venue"; then
  printf '%s\n' "VenueFetcher must use local HTTPS host configuration, retain request tasks, and avoid force unwraps or print diagnostics." >&2
  exit 1
fi

python3 - "$venue" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
if source.count("URLSession.shared.downloadTask(with: url)") != 1:
    raise SystemExit("VenueFetcher must retain one configured download request.")
if source.count("httpResponse.url == url") != 1:
    raise SystemExit("Venue responses must match the exact configured request URL.")
if source.count('self.setError("Venue search returned no data.")') != 1:
    raise SystemExit("Rejected venue responses must retain one generic no-data error.")
required = (
    'private func isJSONResponse(_ response: HTTPURLResponse) -> Bool',
    'response.value(forHTTPHeaderField: "Content-Type")',
    'mediaType == "application/json"',
    'mediaType.hasPrefix("application/")',
    'mediaType.hasSuffix("+json")',
    'self.isJSONResponse(httpResponse)',
)
if any(source.count(item) != 1 for item in required):
    raise SystemExit("Venue responses must use one exact JSON media-type boundary.")
if 'text/html' in source:
    raise SystemExit("Venue JSON media-type validation must not allow HTML.")

response_cast = source.index('response as? HTTPURLResponse')
final_url_guard = source.index('httpResponse.url == url')
status_guard = source.index('(200..<300).contains(httpResponse.statusCode)')
media_guard = source.index('self.isJSONResponse(httpResponse)')
file_metadata = source.index('FileManager.default.attributesOfItem')
file_read = source.index('Data(contentsOf: location)')
if not response_cast < final_url_guard < status_guard < media_guard < file_metadata < file_read:
    raise SystemExit("Venue final URL, status, and JSON media validation must precede file reads.")
PY

image_loader="$ROOT_DIR/FSQNearby/Service/ImageLoader.swift"
python3 - "$image_loader" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
load = source.split("private func load", 1)[-1].split("private func isImageResponse", 1)[0]
required = (
    "URLSession.shared.downloadTask(with: url)",
    "let httpResponse = response as? HTTPURLResponse",
    "httpResponse.url == url",
    "(200..<300).contains(httpResponse.statusCode)",
    "self.isImageResponse(httpResponse)",
    "let attributes = try? FileManager.default.attributesOfItem",
    "let data = try? Data(contentsOf: location)",
)
positions = [load.find(item) for item in required]
if any(load.count(item) != 1 for item in required):
    raise SystemExit("Image loading must keep one request and exact final URL guard.")
if -1 in positions or positions != sorted(positions):
    raise SystemExit("Image final URL validation must precede status, media, file, and data processing.")
PY

if ! grep -Fq 'url.scheme == "https"' "$image_loader" ||
  ! grep -Fq 'url.host?.isEmpty == false' "$image_loader" ||
  ! grep -Fq "url.user == nil" "$image_loader" ||
  ! grep -Fq "url.password == nil" "$image_loader" ||
  ! grep -Fq "url.fragment == nil" "$image_loader" ||
  ! grep -Fq "private var task: URLSessionDownloadTask?" "$image_loader" ||
  ! grep -Fq "deinit" "$image_loader" ||
  ! grep -Fq "task?.cancel()" "$image_loader" ||
  ! grep -Fq "downloadTask(with: url) { [weak self] location, response, error in" "$image_loader" ||
  ! grep -Fq "guard let self = self else { return }" "$image_loader" ||
  ! grep -Fq "!data.isEmpty" "$image_loader" ||
  ! grep -Fq "private let maxImagePayloadBytes = 5 * 1024 * 1024" "$image_loader" ||
  ! grep -Fq "httpResponse.expectedContentLength < 0" "$image_loader" ||
  ! grep -Fq "httpResponse.expectedContentLength <= Int64(self.maxImagePayloadBytes)" "$image_loader" ||
  ! grep -Fq "fileSize.intValue <= self.maxImagePayloadBytes" "$image_loader" ||
  ! grep -Fq "let data = try? Data(contentsOf: location)" "$image_loader" ||
  ! grep -Fq "data.count <= self.maxImagePayloadBytes" "$image_loader" ||
  grep -Fq "URLSession.shared.dataTask" "$image_loader" ||
  grep -Fq "load(urlString: self.url)" "$image_loader"; then
  printf '%s\n' "ImageLoader must require HTTPS URLs with hosts, reject unsafe URL parts, cancel retained tasks, avoid strong task captures, and avoid recursive reloads when data changes." >&2
  exit 1
fi

python3 - "$image_loader" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
required = (
    'private func isImageResponse(_ response: HTTPURLResponse) -> Bool',
    'response.value(forHTTPHeaderField: "Content-Type")',
    '.trimmingCharacters(in: .whitespacesAndNewlines)',
    '.lowercased()',
    'mediaType.hasPrefix("image/")',
    'mediaType.count > "image/".count',
    'self.isImageResponse(httpResponse)',
)
if any(source.count(item) != 1 for item in required):
    raise SystemExit("Image responses must retain one explicit image media-type guard.")

status_guard = source.index('(200..<300).contains(httpResponse.statusCode)')
media_guard = source.index('self.isImageResponse(httpResponse)')
file_read = source.index('FileManager.default.attributesOfItem')
data_read = source.index('Data(contentsOf: location)')
if not status_guard < media_guard < file_read < data_read:
    raise SystemExit("Image media-type validation must precede temporary-file reads.")
PY

if ! grep -Fq "fetcher.errorMessage" "$ROOT_DIR/FSQNearby/View/VenueListView.swift" ||
  ! grep -Fq "No venues found." "$ROOT_DIR/FSQNearby/View/VenueListView.swift"; then
  printf '%s\n' "VenueListView must expose error and empty states." >&2
  exit 1
fi

icon_view="$ROOT_DIR/FSQNearby/View/IconView.swift"
if ! grep -Fq "if let image = UIImage(data: data)" "$icon_view" ||
  grep -Fq "UIImage(data: data) ?? UIImage()" "$icon_view"; then
  printf '%s\n' "IconView must ignore undecodable image data instead of replacing the current image with a blank one." >&2
  exit 1
fi

if grep -Eq 'first!|location\.(address|city|country)!|\(categories\.first!\.icon\?\.iconPrefix\)!' \
  "$ROOT_DIR/FSQNearby/View/AddressView.swift" \
  "$ROOT_DIR/FSQNearby/View/CategoryIconView.swift" \
  "$ROOT_DIR/FSQNearby/View/CategoryView.swift"; then
  printf '%s\n' "Venue view components must avoid force-unwrapping optional response fields." >&2
  exit 1
fi

if grep -R -n 'print(' "$ROOT_DIR/FSQNearby"; then
  printf '%s\n' "Swift source must not use print for runtime diagnostics." >&2
  exit 1
fi

if ! grep -Fq "FOURSQUARE_VENUE_SEARCH_URL" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make lint" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make test" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make build" "$ROOT_DIR/README.md" ||
  ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "HTTPS URL with a host" "$ROOT_DIR/README.md" ||
  ! grep -Fq "image requests are cancelled" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Image URL userinfo and fragments" "$ROOT_DIR/README.md" ||
  ! grep -Fq "empty image response bodies" "$ROOT_DIR/README.md" ||
  ! grep -Fq "undecodable image payloads" "$ROOT_DIR/README.md" ||
  ! grep -Fq "weak task captures" "$ROOT_DIR/README.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/README.md" ||
  ! grep -Fq "App Transport Security" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document local endpoint configuration and verification." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make lint" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make test" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "make build" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "NSAllowsArbitraryLoads" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "HTTPS-only venue and image loading with URL hosts" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Image URL parsing rejects embedded userinfo and fragments" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Image loading retains and cancels URLSession tasks" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Empty image response bodies are ignored" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Undecodable image payloads are ignored" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "weak task captures" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "FOURSQUARE_VENUE_SEARCH_URL" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current transport baseline." >&2
  exit 1
fi

if ! grep -Fq "Resolved on 2026-06-08" "$ROOT_DIR/docs/bugs/p2-ios-global-ats-bypass-d3b1b3edbda3cef9.md"; then
  printf '%s\n' "ATS bug record must include the local resolution." >&2
  exit 1
fi

if ! grep -Fq "Undecodable image payloads should be ignored" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document the undecodable image payload boundary." >&2
  exit 1
fi

if ! grep -Fq "GitHub Actions" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "SECURITY must document the GitHub Actions baseline." >&2
  exit 1
fi

if ! grep -Fq "*.xcconfig" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq ".env" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' "Local config files must stay ignored." >&2
  exit 1
fi

if command -v xcodebuild >/dev/null 2>&1; then
  xcodebuild -list -project "$ROOT_DIR/FSQNearby.xcodeproj"
else
  printf '%s\n' "Skipping xcodebuild project listing: xcodebuild is not installed."
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$HOST_PLAN"; then
  printf '%s\n' "URL host validation plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IMAGE_TASK_PLAN"; then
  printf '%s\n' "Image task lifecycle plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$VENUE_TASK_PLAN"; then
  printf '%s\n' "Venue task lifecycle plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IMAGE_CAPTURE_PLAN"; then
  printf '%s\n' "Image weak capture plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$VENUE_URL_PARTS_PLAN"; then
  printf '%s\n' "Venue URL parts plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$MAKE_GATES_PLAN"; then
  printf '%s\n' "Make gate alias plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IMAGE_URL_PARTS_PLAN"; then
  printf '%s\n' "Image URL parts plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IMAGE_EMPTY_DATA_PLAN"; then
  printf '%s\n' "Image empty data plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IMAGE_DECODE_PLAN"; then
  printf '%s\n' "Image decode guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IMAGE_SIZE_PLAN"; then
  printf '%s\n' "Image size boundary plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$VENUE_SIZE_PLAN" ||
  ! grep -Fq "make check" "$VENUE_SIZE_PLAN"; then
  printf '%s\n' "Venue response size boundary plan must be completed and record verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$VENUE_CONTENT_TYPE_PLAN" ||
  ! grep -Fq "media-type guard mutation failed" "$VENUE_CONTENT_TYPE_PLAN" ||
  ! grep -Fq "HTML allowlist mutation failed" "$VENUE_CONTENT_TYPE_PLAN" ||
  ! grep -Fq "late validation mutation failed" "$VENUE_CONTENT_TYPE_PLAN" ||
  ! grep -Fq "hosted pull-request check" "$VENUE_CONTENT_TYPE_PLAN"; then
  printf '%s\n' "Venue content-type boundary plan must record completed verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IMAGE_CONTENT_TYPE_PLAN" ||
  ! grep -Fq "media-type helper mutation failed" "$IMAGE_CONTENT_TYPE_PLAN" ||
  ! grep -Fq "HTML allowlist mutation failed" "$IMAGE_CONTENT_TYPE_PLAN" ||
  ! grep -Fq "late validation mutation failed" "$IMAGE_CONTENT_TYPE_PLAN" ||
  ! grep -Fq "hosted pull-request check" "$IMAGE_CONTENT_TYPE_PLAN"; then
  printf '%s\n' "Image content-type boundary plan must record completed verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$IMAGE_EMPTY_DATA_PLAN"; then
  printf '%s\n' "Image empty data plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$IMAGE_DECODE_PLAN"; then
  printf '%s\n' "Image decode guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "contents: read" "$CI_WORKFLOW" || \
   ! grep -Fq "cancel-in-progress: true" "$CI_WORKFLOW" || \
   ! grep -Fq "runs-on: macos-15" "$CI_WORKFLOW" || \
   ! grep -Fq "timeout-minutes: 10" "$CI_WORKFLOW" || \
   ! grep -Fq "actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10" "$CI_WORKFLOW" || \
   ! grep -Fq "actions/setup-python@a309ff8b426b58ec0e2a45f0f869d46889d02405" "$CI_WORKFLOW" || \
   ! grep -Fq "run: make check" "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must keep the bounded, least-privilege macOS check contract." >&2
  exit 1
fi

if [ "$(grep -Fc "uses: actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10" "$CI_WORKFLOW")" -ne 1 ] || \
   [ "$(grep -Fc "persist-credentials: false" "$CI_WORKFLOW")" -ne 1 ]; then
  printf '%s\n' "GitHub Actions must use one pinned checkout without persisting credentials." >&2
  exit 1
fi

if ! awk '
  /uses: actions\/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10/ { checkout = 1; next }
  checkout && /^[[:space:]]+with:[[:space:]]*$/ { options = 1; next }
  checkout && options && /^[[:space:]]+persist-credentials: false[[:space:]]*$/ { protected = 1; next }
  checkout && /^[[:space:]]+- / { exit }
  END { exit protected ? 0 : 1 }
' "$CI_WORKFLOW"; then
  printf '%s\n' "Checkout credential persistence must be disabled on the pinned checkout step." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$CI_PLAN" || ! grep -Fq "make check" "$CI_PLAN"; then
  printf '%s\n' "Foursquare Search SwiftUI CI baseline plan must record completed status and make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CHECKOUT_CREDENTIAL_PLAN" || \
   ! grep -Fq 'local `make check` passed' "$CHECKOUT_CREDENTIAL_PLAN" || \
   ! grep -Fq "external working directory" "$CHECKOUT_CREDENTIAL_PLAN" || \
   ! grep -Fq "hostile mutations were rejected" "$CHECKOUT_CREDENTIAL_PLAN"; then
  printf '%s\n' "Checkout credential boundary plan must record completed verification." >&2
  exit 1
fi

if ! grep -Fq "does not persist checkout credentials" "$ROOT_DIR/README.md" || \
   ! grep -Fq "does not persist checkout credentials" "$ROOT_DIR/SECURITY.md" || \
   ! grep -Fq "credential-free Xcode project parse" "$ROOT_DIR/VISION.md" || \
   ! grep -Fq "Stopped GitHub Actions checkout credential persistence" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must document the checkout credential boundary." >&2
  exit 1
fi

if ! grep -Fq "explicit JSON Content-Type" "$ROOT_DIR/README.md" || \
   ! grep -Fq "explicit JSON media type" "$ROOT_DIR/SECURITY.md" || \
   ! grep -Fq "explicit JSON media types" "$ROOT_DIR/VISION.md" || \
   ! grep -Fq "Required explicit JSON response media types" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must document the venue JSON media-type boundary." >&2
  exit 1
fi

if ! grep -Fq "exact final venue response URL" "$ROOT_DIR/README.md" || \
   ! grep -Fq "exact final venue response URL" "$ROOT_DIR/SECURITY.md" || \
   ! grep -Fq "exact final venue response URL" "$ROOT_DIR/VISION.md" || \
   ! grep -Fq "exact final venue response URL" "$ROOT_DIR/CHANGES.md" || \
   ! grep -Fq "exact final venue response URL" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must document the venue final URL boundary." >&2
  exit 1
fi

python3 - "$VENUE_FINAL_URL_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "guard removal mutation failed",
    "host-only mutation failed",
    "validation ordering mutation failed",
    "duplicate request mutation failed",
    "error weakening mutation failed",
    "plan evidence mutation failed",
    "hosted pull-request check",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit("Venue final URL plan must remain completed with actual verification recorded.")
PY

python3 - "$IMAGE_FINAL_URL_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
required = (
    "five hostile mutations were rejected",
    "all four Make gates passed",
    "xcodebuild was unavailable",
    "No live image request",
)
if statuses != ["status: completed"] or any(item not in plan for item in required):
    raise SystemExit("Image final URL plan must record completed local verification.")
PY

if ! grep -Fq "exact final image response URL" "$ROOT_DIR/README.md" ||
  ! grep -Fq "exact final URL should match" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "exact request URL provenance" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Required exact final image response URLs" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "exact final image response URL validation" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project docs must preserve image response provenance validation." >&2
  exit 1
fi

printf '%s\n' "foursquare-search-swiftui transport baseline checks passed."
