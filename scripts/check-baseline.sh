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
VENUE_REDIRECT_PLAN="$ROOT_DIR/docs/plans/2026-06-15-foursquare-venue-redirect-refusal.md"
IMAGE_REDIRECT_PLAN="$ROOT_DIR/docs/plans/2026-06-15-foursquare-image-redirect-refusal.md"
NETWORK_TIMEOUT_PLAN="$ROOT_DIR/docs/plans/2026-06-15-swiftui-network-timeouts.md"
NETWORK_TIMEOUT_CHECK="$ROOT_DIR/scripts/check-swiftui-network-timeouts.py"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-ci-baseline.md"
CHECKOUT_CREDENTIAL_PLAN="$ROOT_DIR/docs/plans/2026-06-12-checkout-credential-boundary.md"
HOSTED_BUILD_PLAN="$ROOT_DIR/docs/plans/2026-06-16-hosted-simulator-build.md"
ENVELOPE_STATUS_PLAN="$ROOT_DIR/docs/plans/2026-06-17-foursquare-envelope-status.md"
VENUE_TEXT_PLAN="$ROOT_DIR/docs/plans/2026-06-18-foursquare-swiftui-venue-name-boundary.md"
SWIFT_RUNNER_SIGNAL_PLAN="$ROOT_DIR/docs/plans/2026-06-18-foursquare-swift-runner-signal-cleanup.md"
VENUE_OWNERSHIP_PLAN="$ROOT_DIR/docs/plans/2026-06-26-venue-fetcher-root-ownership.md"

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
  "FSQNearby/ContentView.swift" \
  "FSQNearby/Service/VenueFetcher.swift" \
  "FSQNearby/Service/FoursquareEnvelopePolicy.swift" \
  "FSQNearby/Service/FoursquareVenueTextPolicy.swift" \
  "FSQNearby/Service/ImageDecodePolicy.swift" \
  "FSQNearby/Service/ImageLoader.swift" \
  "FSQNearby/View/AddressView.swift" \
  "FSQNearby/View/CategoryIconView.swift" \
  "FSQNearby/View/CategoryView.swift" \
  "FSQNearby/View/IconView.swift" \
  "FSQNearby/View/VenueListView.swift" \
  "docs/plans/2026-06-26-venue-fetcher-root-ownership.md" \
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
  "docs/plans/2026-06-15-foursquare-venue-redirect-refusal.md" \
  "docs/plans/2026-06-15-foursquare-image-redirect-refusal.md" \
  "docs/plans/2026-06-15-swiftui-network-timeouts.md" \
  "scripts/check-swiftui-network-timeouts.py" \
  "scripts/check-venue-fetcher-ownership.py" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-url-parts.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-venue-url-parts.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-make-gate-aliases.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-weak-capture.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-task-lifecycle.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-url-host-validation.md" \
  "docs/plans/2026-06-10-ci-baseline.md" \
  "docs/plans/2026-06-12-checkout-credential-boundary.md" \
  "docs/plans/2026-06-16-hosted-simulator-build.md" \
  "docs/plans/2026-06-17-foursquare-envelope-status.md" \
  "docs/plans/2026-06-18-foursquare-swiftui-venue-name-boundary.md" \
  "docs/plans/2026-06-18-foursquare-swift-runner-signal-cleanup.md" \
  "scripts/run-foursquare-envelope-policy-tests.sh" \
  "scripts/run-foursquare-venue-text-tests.sh" \
  "scripts/run-image-decode-policy-tests.sh" \
  "Tests/FoursquareEnvelopePolicyTests/main.swift" \
  "Tests/FoursquareVenueTextPolicyTests/main.swift" \
  "Tests/ImageDecodePolicyTests/main.swift" \
  ".github/workflows/check.yml" \
  "docs/plans/2026-06-08-foursquare-search-swiftui-transport-baseline.md"; do
  require_file "$path"
done

python3 "$NETWORK_TIMEOUT_CHECK" \
  "$ROOT_DIR/FSQNearby/Service/VenueFetcher.swift" \
  "$ROOT_DIR/FSQNearby/Service/ImageLoader.swift"

for network_timeout_doc in AGENTS.md README.md SECURITY.md VISION.md CHANGES.md; do
  if ! grep -Fq "SwiftUI venue and image networking use 15-second request timeouts and 30-second resource timeouts." "$ROOT_DIR/$network_timeout_doc"; then
    printf '%s\n' "$network_timeout_doc must document bounded SwiftUI network timeouts." >&2
    exit 1
  fi
done

for network_timeout_plan_contract in \
  "status: completed" \
  "## Status: Completed" \
  "## Work Completed" \
  "## Verification Completed" \
  "hostile mutations were rejected"; do
  if ! grep -Fq "$network_timeout_plan_contract" "$NETWORK_TIMEOUT_PLAN"; then
    printf '%s\n' "SwiftUI timeout plan must record completed evidence: $network_timeout_plan_contract" >&2
    exit 1
  fi
done

if ! grep -Fq 'override ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))' "$ROOT_DIR/Makefile" ||
  ! grep -Fq '"$(ROOT)/scripts/check-baseline.sh"' "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile verification must protect the loaded Makefile root from overrides." >&2
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
  ! grep -Fq "venueSession.invalidateAndCancel()" "$venue" ||
  ! grep -Fq "task?.resume()" "$venue" ||
  ! grep -Fq "private let maxVenuePayloadBytes = 2 * 1024 * 1024" "$venue" ||
  ! grep -Fq "httpResponse.expectedContentLength < 0" "$venue" ||
  ! grep -Fq "httpResponse.expectedContentLength <= Int64(self.maxVenuePayloadBytes)" "$venue" ||
  ! grep -Fq "let attributes = try? FileManager.default.attributesOfItem(atPath: location.path)" "$venue" ||
  ! grep -Fq "fileSize.intValue <= self.maxVenuePayloadBytes" "$venue" ||
  ! grep -Fq "let data = try? Data(contentsOf: location)" "$venue" ||
  ! grep -Fq "!data.isEmpty" "$venue" ||
  ! grep -Fq "data.count <= self.maxVenuePayloadBytes" "$venue" ||
  grep -Fq "URLSession.shared" "$venue" ||
  grep -Fq 'URL(string: "FOURSQUARE_VENUE_SEARCH")!' "$venue" ||
  grep -Eq 'responseData\?\.(venues)\)!|URL\(string:.*\)!|print\(' "$venue"; then
  printf '%s\n' "VenueFetcher must use local HTTPS host configuration, retain request tasks, and avoid force unwraps or print diagnostics." >&2
  exit 1
fi

python3 - "$venue" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text()
redirect_contract = (
    "private final class VenueRedirectRejectingDelegate: NSObject, URLSessionTaskDelegate",
    "willPerformHTTPRedirection response: HTTPURLResponse",
    "completionHandler: @escaping (URLRequest?) -> Void",
    "completionHandler(nil)",
    "private let sessionDelegate: VenueRedirectRejectingDelegate",
    "private let venueSession: URLSession",
    "let sessionDelegate = VenueRedirectRejectingDelegate()",
    "let configuration = URLSessionConfiguration.default",
    "self.sessionDelegate = sessionDelegate",
    "self.venueSession = URLSession(",
    "configuration: configuration",
    "delegate: sessionDelegate",
    "venueSession.invalidateAndCancel()",
)
if any(source.count(item) != 1 for item in redirect_contract):
    raise SystemExit("VenueFetcher must retain one configured session that refuses redirects.")
if source.count("venueSession.downloadTask(with: url)") != 1:
    raise SystemExit("VenueFetcher must retain one configured redirect-refusing download request.")
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
redirect_contract = (
    "private final class ImageRedirectRejectingDelegate: NSObject, URLSessionTaskDelegate",
    "willPerformHTTPRedirection response: HTTPURLResponse",
    "completionHandler: @escaping (URLRequest?) -> Void",
    "completionHandler(nil)",
    "private let sessionDelegate: ImageRedirectRejectingDelegate",
    "private let imageSession: URLSession",
    "let sessionDelegate = ImageRedirectRejectingDelegate()",
    "let configuration = URLSessionConfiguration.default",
    "self.sessionDelegate = sessionDelegate",
    "self.imageSession = URLSession(",
    "configuration: configuration",
    "delegate: sessionDelegate",
    "imageSession.invalidateAndCancel()",
)
if any(source.count(item) != 1 for item in redirect_contract):
    raise SystemExit("ImageLoader must retain one configured session that refuses redirects.")
if source.count("imageSession.downloadTask(with: url)") != 1:
    raise SystemExit("ImageLoader must retain one configured redirect-refusing download request.")
if source.count("httpResponse.url == url") != 1:
    raise SystemExit("Image responses must retain the exact final URL guard.")

load = source.split("private func load", 1)[-1].split("private func isImageResponse", 1)[0]
required = (
    "imageSession.downloadTask(with: url)",
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

python3 "$ROOT_DIR/scripts/check-venue-fetcher-ownership.py"
python3 "$ROOT_DIR/scripts/check-venue-fetcher-ownership.py" --mutation-test

for ownership_evidence in \
  "status: completed" \
  "9a2d73fc78d8ea6c64f5c2376c536b4aa3a9fb0d" \
  "28247639075" \
  "28247642376" \
  "28247640315" \
  "Actions, Python, and Swift" \
  "no live Foursquare request or credential"; do
  if ! grep -Fq "$ownership_evidence" "$VENUE_OWNERSHIP_PLAN"; then
    printf '%s\n' "Venue fetcher ownership plan must preserve completed evidence: $ownership_evidence" >&2
    exit 1
  fi
done

for ownership_guidance in \
  "hosted SwiftUI root owns one" \
  "hosted SwiftUI root should own" \
  "hosted SwiftUI root owns one venue fetcher" \
  "venue fetcher owned by the hosted SwiftUI root"; do
  case "$ownership_guidance" in
    *should*) document="$ROOT_DIR/SECURITY.md" ;;
    *"owns one venue"*) document="$ROOT_DIR/VISION.md" ;;
    *"owned by"*) document="$ROOT_DIR/AGENTS.md" ;;
    *) document="$ROOT_DIR/README.md" ;;
  esac
  if ! grep -Fq "$ownership_guidance" "$document"; then
    printf '%s\n' "Project guidance must preserve root-owned venue fetcher behavior: $ownership_guidance" >&2
    exit 1
  fi
done

icon_view="$ROOT_DIR/FSQNearby/View/IconView.swift"
if ! grep -Fq "let image = UIImage(data: data)" "$icon_view" ||
  ! grep -Fq "ImageDecodePolicy.acceptsImageData(data)" "$icon_view" ||
  grep -Fq "UIImage(data: data) ?? UIImage()" "$icon_view"; then
  printf '%s\n' "IconView must reject unbounded or undecodable image data instead of replacing the current image with a blank one." >&2
  exit 1
fi

python3 - \
  "$ROOT_DIR/FSQNearby/Service/ImageDecodePolicy.swift" \
  "$ROOT_DIR/Tests/ImageDecodePolicyTests/main.swift" \
  "$ROOT_DIR/scripts/run-image-decode-policy-tests.sh" \
  "$ROOT_DIR/FSQNearby.xcodeproj/project.pbxproj" \
  "$ROOT_DIR/Makefile" <<'PY'
import os
import sys
from pathlib import Path

policy = Path(sys.argv[1]).read_text()
tests = Path(sys.argv[2]).read_text()
runner = Path(sys.argv[3]).read_text()
project = Path(sys.argv[4]).read_text()
makefile = Path(sys.argv[5]).read_text()

for item in (
    "CGImageSourceCreateWithData",
    "CGImageSourceCopyPropertiesAtIndex",
    "kCGImagePropertyPixelWidth",
    "kCGImagePropertyPixelHeight",
    "maxPixelDimension = 4_096",
    "maxDecodedPixels = 4_000_000",
    "maxDecodedPixels / pixelHeight",
):
    if item not in policy:
        raise SystemExit("Image decode policy must inspect image metadata and enforce decoded pixel bounds.")
for case in (
    "pixelWidth: 64, pixelHeight: 64",
    "pixelWidth: 2_000, pixelHeight: 2_000",
    "pixelWidth: 4_097, pixelHeight: 1",
    "pixelWidth: 1, pixelHeight: 4_097",
    "pixelWidth: 2_000, pixelHeight: 2_001",
    "acceptsImageData(onePixelPNG)",
    "acceptsImageData(randomBytes)",
    "acceptsImageData(Data())",
):
    if case not in tests:
        raise SystemExit("Executable image decode policy cases must remain registered.")
if "FSQNearby/Service/ImageDecodePolicy.swift" not in runner or "Tests/ImageDecodePolicyTests/main.swift" not in runner:
    raise SystemExit("Image decode runner must compile production policy and its focused tests.")
if 'mktemp -d "${TMPDIR:-/tmp}/image-decode-policy-tests.XXXXXX"' not in runner or 'rm -rf -- "$BUILD_DIR"' not in runner:
    raise SystemExit("Image decode runner must use and clean a bounded temporary build directory.")
if not os.access(sys.argv[3], os.X_OK):
    raise SystemExit("Image decode runner must remain executable.")
if project.count("ImageDecodePolicy.swift in Sources") != 2 or project.count("/* ImageDecodePolicy.swift */") != 3:
    raise SystemExit("Image decode policy must remain a member of the app target.")
if makefile.count("run-image-decode-policy-tests.sh") != 1:
    raise SystemExit("The canonical Make gate must execute the image decode policy harness once.")
PY

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
  build_root=$(mktemp -d "${TMPDIR:-/tmp}/fsqnearby-build.XXXXXX")
  cleanup_build_root() {
    if [ -n "${build_root:-}" ] && [ -d "$build_root" ]; then
      rm -rf -- "$build_root"
    fi
  }
  trap cleanup_build_root 0 1 2 15
  xcodebuild -list -project "$ROOT_DIR/FSQNearby.xcodeproj"
  xcodebuild \
    -project "$ROOT_DIR/FSQNearby.xcodeproj" \
    -target FSQNearby \
    -sdk iphonesimulator \
    -configuration Debug \
    CODE_SIGNING_ALLOWED=NO \
    CODE_SIGNING_REQUIRED=NO \
    ONLY_ACTIVE_ARCH=NO \
    SYMROOT="$build_root/products" \
    OBJROOT="$build_root/intermediates" \
    build
  cleanup_build_root
  build_root=
  trap - 0 1 2 15
else
  printf '%s\n' "Skipping xcodebuild project listing and simulator build: xcodebuild is not installed."
fi

if ! grep -Fq "status: completed" "$HOSTED_BUILD_PLAN" || \
   ! grep -Fq "repository and external-directory make check passed" "$HOSTED_BUILD_PLAN" || \
   ! grep -Fq "hostile hosted-build mutations were rejected" "$HOSTED_BUILD_PLAN" || \
   ! grep -Fq "xcodebuild is unavailable on Linux" "$HOSTED_BUILD_PLAN" || \
   ! grep -Fq "hosted push and pull-request builds passed" "$HOSTED_BUILD_PLAN" || \
   ! grep -Fq "27639736142" "$HOSTED_BUILD_PLAN" || \
   ! grep -Fq "27639743099" "$HOSTED_BUILD_PLAN"; then
  printf '%s\n' "Hosted simulator build plan must record completed local and hosted evidence." >&2
  exit 1
fi

for hosted_build_contract in \
  'build_root=$(mktemp -d "${TMPDIR:-/tmp}/fsqnearby-build.XXXXXX")' \
  'trap cleanup_build_root 0 1 2 15' \
  '-target FSQNearby' \
  '-sdk iphonesimulator' \
  'CODE_SIGNING_ALLOWED=NO' \
  'CODE_SIGNING_REQUIRED=NO' \
  'SYMROOT="$build_root/products"' \
  'OBJROOT="$build_root/intermediates"' \
  'trap - 0 1 2 15'; do
  if ! grep -Fq -- "$hosted_build_contract" "$ROOT_DIR/scripts/check-baseline.sh"; then
    printf '%s\n' "Hosted simulator build contract is missing: $hosted_build_contract" >&2
    exit 1
  fi
done

if [ "$(grep -Ec '^  xcodebuild \\$' "$ROOT_DIR/scripts/check-baseline.sh")" -ne 1 ]; then
  printf '%s\n' "Hosted simulator compilation must invoke exactly one multiline xcodebuild command." >&2
  exit 1
fi

for counted_contract in \
  '-target FSQNearby' \
  '-sdk iphonesimulator' \
  'CODE_SIGNING_ALLOWED=NO' \
  'trap cleanup_build_root 0 1 2 15'; do
  if [ "$(grep -Fc -- "$counted_contract" "$ROOT_DIR/scripts/check-baseline.sh")" -ne 3 ]; then
    printf '%s\n' "Hosted simulator build contract must appear in implementation and guard: $counted_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "Run baseline and compile Swift sources" "$CI_WORKFLOW" || \
   ! grep -Fq "run: make check" "$CI_WORKFLOW"; then
  printf '%s\n' "Canonical macOS CI must execute the hosted compile gate." >&2
  exit 1
fi

for hosted_build_doc in AGENTS.md README.md SECURITY.md VISION.md CHANGES.md; do
  if ! grep -Fq "Hosted simulator builds compile all fifteen Swift sources with signing disabled." "$ROOT_DIR/$hosted_build_doc"; then
    printf '%s\n' "$hosted_build_doc must document hosted simulator compilation." >&2
    exit 1
  fi
done

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

python3 - "$VENUE_SIZE_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "All four Make gates",
    "push run `27392594720`",
    "pull-request run `27392598472`",
    "push run `27392614649`",
    "CodeQL run `27402320529`",
)

if (
    statuses != ["status: completed"]
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Venue response size boundary plan must remain completed with actual verification recorded."
    )
PY

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

if ! grep -Fq "dedicated venue session refuses redirects" "$ROOT_DIR/README.md" ||
  ! grep -Fq "dedicated venue session must refuse redirects" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "dedicated venue session refuses redirects" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Refused redirects in the dedicated venue session" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "dedicated venue session configured" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must document venue redirect refusal." >&2
  exit 1
fi

if ! grep -Fq "dedicated image session refuses redirects" "$ROOT_DIR/README.md" ||
  ! grep -Fq "dedicated image session must refuse redirects" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "dedicated image session refuses redirects" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Refused redirects in the dedicated image session" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "dedicated image session configured" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must document image redirect refusal." >&2
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

python3 - "$VENUE_REDIRECT_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "delegate removal mutation failed",
    "redirect acceptance mutation failed",
    "shared session mutation failed",
    "duplicate request mutation failed",
    "final URL guard mutation failed",
    "plan evidence mutation failed",
    "hosted pull-request check",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit("Venue redirect refusal plan must remain completed with actual verification recorded.")
PY

python3 - "$IMAGE_REDIRECT_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "delegate removal mutation failed",
    "redirect acceptance mutation failed",
    "delegate retention mutation failed",
    "default session mutation failed",
    "duplicate request mutation failed",
    "final URL guard mutation failed",
    "guidance mutation failed",
    "plan evidence mutation failed",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit("Image redirect refusal plan must remain completed with actual verification recorded.")
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

python3 - \
  "$ROOT_DIR/FSQNearby/Service/FoursquareEnvelopePolicy.swift" \
  "$ROOT_DIR/FSQNearby/Service/VenueFetcher.swift" \
  "$ROOT_DIR/Tests/FoursquareEnvelopePolicyTests/main.swift" \
  "$ROOT_DIR/FSQNearby.xcodeproj/project.pbxproj" \
  "$ROOT_DIR/Makefile" \
  "$ENVELOPE_STATUS_PLAN" <<'PY'
import sys
from pathlib import Path

policy = Path(sys.argv[1]).read_text()
fetcher = Path(sys.argv[2]).read_text()
tests = Path(sys.argv[3]).read_text()
project = Path(sys.argv[4]).read_text()
makefile = Path(sys.argv[5]).read_text()
plan = " ".join(Path(sys.argv[6]).read_text().split())

if "metaCode == 200 && hasResponse" not in policy:
    raise SystemExit("Decoded Foursquare envelopes must require status 200 and a response object.")
if "FoursquareEnvelopePolicy.accepts(" not in fetcher or "let response = foursquareSearch.response" not in fetcher:
    raise SystemExit("Venue publication must delegate to the decoded-envelope policy.")
for case in (
    'metaCode: 200, hasResponse: true, accepted: true',
    'metaCode: nil, hasResponse: true, accepted: false',
    'metaCode: 400, hasResponse: true, accepted: false',
    'metaCode: 500, hasResponse: true, accepted: false',
    'metaCode: 200, hasResponse: false, accepted: false',
):
    if case not in tests:
        raise SystemExit("Executable decoded-envelope cases must remain registered.")
if project.count("FoursquareEnvelopePolicy.swift in Sources") != 2 or project.count("/* FoursquareEnvelopePolicy.swift */") != 3:
    raise SystemExit("Foursquare envelope policy must remain a member of the app target.")
if "run-foursquare-envelope-policy-tests.sh" not in makefile:
    raise SystemExit("The canonical Make gate must execute the envelope policy harness.")
required_plan = (
    "status: completed",
    "Repository-root and external-directory `make check` passed",
    "Eight isolated mutations were rejected",
    "Both exact-head push and pull-request checks passed",
    "`92b1999679545b0cb4ace2ef28e3f49e6ffc7b21`",
    "Push run `27674042876`",
    "pull-request run `27674052161`",
    "no live Foursquare request was made",
)
if any(item not in plan for item in required_plan):
    raise SystemExit("Foursquare envelope plan must record truthful local and hosted evidence.")
PY

python3 - \
  "$ROOT_DIR/scripts/run-foursquare-envelope-policy-tests.sh" \
  "$ROOT_DIR/scripts/run-foursquare-venue-text-tests.sh" \
  "$SWIFT_RUNNER_SIGNAL_PLAN" <<'PY'
import os
import re
import sys
from pathlib import Path

runners = [Path(path) for path in sys.argv[1:3]]
plan = Path(sys.argv[3]).read_text()

handler = re.compile(
    r"handle_signal\(\) \{\n"
    r"    status=\$1\n"
    r"    trap - 0 1 2 15\n"
    r"    cleanup\n"
    r"    exit \"\$status\"\n"
    r"\}"
)
bindings = (
    "trap 'handle_signal 129' 1",
    "trap 'handle_signal 130' 2",
    "trap 'handle_signal 143' 15",
)

for runner in runners:
    source = runner.read_text()
    if not handler.search(source):
        raise SystemExit(f"{runner.name} must clean its temporary directory before signal exit.")
    if any(binding not in source for binding in bindings):
        raise SystemExit(f"{runner.name} must bind HUP, INT, and TERM to the cleanup handler.")
    if re.search(r"trap 'exit (?:129|130|143)'", source):
        raise SystemExit(f"{runner.name} must not use exit-only signal traps.")
    if not os.access(runner, os.X_OK):
        raise SystemExit(f"{runner.name} must remain executable.")

frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification_heading = "## Verification Completed\n"
verification = plan.split(verification_heading, 1)[-1]
required_evidence = (
    "status: completed",
    "Completed. The runner changes",
    "compiler status 42",
    "TERM status 143",
    "Absolute-Makefile `make check` also passed from `/tmp`",
    "Isolated mutations removing direct cleanup",
    "`7fe403ad832c8b4124a61741462bb89970d5b4f7`",
    "push run `27747867228`",
    "pull-request run `27747868221`",
    "no live Foursquare request",
)
if (
    statuses != ["status: completed"]
    or verification_heading not in plan
    or any(item not in plan for item in required_evidence)
    or re.search(r"\b(?:pending|todo|tbd|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit("Swift runner signal cleanup plan must record completed local and hosted evidence.")
PY

if ! grep -Fq "decoded Foursquare envelope requires meta code 200" "$ROOT_DIR/README.md" || \
  ! grep -Fq "decoded envelope must require meta code 200" "$ROOT_DIR/SECURITY.md" || \
  ! grep -Fq "Require successful decoded Foursquare envelopes" "$ROOT_DIR/VISION.md" || \
  ! grep -Fq "Required successful decoded Foursquare envelopes" "$ROOT_DIR/CHANGES.md" || \
  ! grep -Fq "Require decoded Foursquare meta code 200" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must preserve decoded Foursquare envelope validation." >&2
  exit 1
fi

if ! grep -Fq "exact final image response URL" "$ROOT_DIR/README.md" ||
  ! grep -Fq "exact final URL should match" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "exact request URL provenance" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Required exact final image response URLs" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "exact final image response URL validation" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project docs must preserve image response provenance validation." >&2
  exit 1
fi

python3 - \
  "$ROOT_DIR/FSQNearby/Service/FoursquareVenueTextPolicy.swift" \
  "$ROOT_DIR/FSQNearby/Service/VenueFetcher.swift" \
  "$ROOT_DIR/FSQNearby/View/VenueItemView.swift" \
  "$ROOT_DIR/Tests/FoursquareVenueTextPolicyTests/main.swift" \
  "$ROOT_DIR/scripts/run-foursquare-venue-text-tests.sh" \
  "$ROOT_DIR/FSQNearby.xcodeproj/project.pbxproj" \
  "$ROOT_DIR/Makefile" \
  "$VENUE_TEXT_PLAN" <<'PY'
import os
import re
import sys
from pathlib import Path

policy = Path(sys.argv[1]).read_text()
fetcher = Path(sys.argv[2]).read_text()
view = Path(sys.argv[3]).read_text()
tests = Path(sys.argv[4]).read_text()
runner = Path(sys.argv[5]).read_text()
project = Path(sys.argv[6]).read_text()
makefile = Path(sys.argv[7]).read_text()
plan = Path(sys.argv[8]).read_text()

if "trimmingCharacters(in: .whitespacesAndNewlines)" not in policy or "normalized.isEmpty ? nil : normalized" not in policy:
    raise SystemExit("Venue names must trim surrounding whitespace and reject empty values.")
if "response.venues.filter" not in fetcher or "FoursquareVenueTextPolicy.normalizedName($0.name) != nil" not in fetcher:
    raise SystemExit("Venue publication must reject invalid names through the production policy.")
if "Text(FoursquareVenueTextPolicy.displayName(self.venue.name))" not in view:
    raise SystemExit("Venue rows must render the normalized production-policy name.")
if "Text(self.venue.name)" in view:
    raise SystemExit("Venue rows must not render the unvalidated raw name.")
for case in (
    'expectName("Coffee Shop", normalized: "Coffee Shop"',
    'expectName("", normalized: nil',
    'expectName(" \\t\\n ", normalized: nil',
    'expectName("  Café 東京  ", normalized: "Café 東京"',
    'expectDisplayName("\\n", expected: "Venue"',
):
    if case not in tests:
        raise SystemExit("Executable venue-name cases must remain registered.")
if "FSQNearby/Service/FoursquareVenueTextPolicy.swift" not in runner or "Tests/FoursquareVenueTextPolicyTests/main.swift" not in runner:
    raise SystemExit("Venue text runner must compile production policy and its focused tests.")
if 'mktemp -d "${TMPDIR:-/tmp}/foursquare-venue-text-tests.XXXXXX"' not in runner or 'rm -rf -- "$BUILD_DIR"' not in runner:
    raise SystemExit("Venue text runner must use and clean a bounded temporary build directory.")
if not os.access(sys.argv[5], os.X_OK):
    raise SystemExit("Venue text runner must remain executable.")
if project.count("FoursquareVenueTextPolicy.swift in Sources") != 2 or project.count("/* FoursquareVenueTextPolicy.swift */") != 3:
    raise SystemExit("Venue text policy must remain a member of the app target.")
if makefile.count("run-foursquare-venue-text-tests.sh") != 1:
    raise SystemExit("The canonical Make gate must execute the venue text harness once.")
frontmatter = plan.split("---", 2)[1]
statuses = re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required_plan = (
    "Repository-root and external-directory `make check` passed",
    "isolated mutations were rejected",
    "Both exact-head push and pull-request checks passed",
    "`8b17732daa3125d5bf373fb565881119b52889a0`",
    "Push run `27739743924`",
    "pull-request run `27739751280`",
    "No live Foursquare request was made",
)
if (
    statuses != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required_plan)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit("Venue text plan must record completed local and hosted verification.")
PY

if ! grep -Fq "blank venue names are rejected before publication" "$ROOT_DIR/README.md" || \
  ! grep -Fq "blank venue names must be rejected before publication" "$ROOT_DIR/SECURITY.md" || \
  ! grep -Fq "Reject blank venue names before publication" "$ROOT_DIR/VISION.md" || \
  ! grep -Fq "Rejected blank Foursquare venue names before publication" "$ROOT_DIR/CHANGES.md" || \
  ! grep -Fq "Reject blank decoded venue names before publishing" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must preserve the venue-name integrity boundary." >&2
  exit 1
fi

printf '%s\n' "foursquare-search-swiftui transport baseline checks passed."
