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
  "FSQNearby/View/VenueListView.swift" \
  "docs/bugs/p2-ios-global-ats-bypass-d3b1b3edbda3cef9.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-venue-task-lifecycle.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-venue-url-parts.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-make-gate-aliases.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-weak-capture.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-image-task-lifecycle.md" \
  "docs/plans/2026-06-09-foursquare-swiftui-url-host-validation.md" \
  "docs/plans/2026-06-08-foursquare-search-swiftui-transport-baseline.md"; do
  require_file "$path"
done

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
  ! grep -Fq "private var task: URLSessionDataTask?" "$venue" ||
  ! grep -Fq "deinit" "$venue" ||
  ! grep -Fq "task?.cancel()" "$venue" ||
  ! grep -Fq "task?.resume()" "$venue" ||
  grep -Fq 'URL(string: "FOURSQUARE_VENUE_SEARCH")!' "$venue" ||
  grep -Eq 'responseData\?\.(venues)\)!|URL\(string:.*\)!|print\(' "$venue"; then
  printf '%s\n' "VenueFetcher must use local HTTPS host configuration, retain request tasks, and avoid force unwraps or print diagnostics." >&2
  exit 1
fi

image_loader="$ROOT_DIR/FSQNearby/Service/ImageLoader.swift"
if ! grep -Fq 'url.scheme == "https"' "$image_loader" ||
  ! grep -Fq 'url.host?.isEmpty == false' "$image_loader" ||
  ! grep -Fq "private var task: URLSessionDataTask?" "$image_loader" ||
  ! grep -Fq "deinit" "$image_loader" ||
  ! grep -Fq "task?.cancel()" "$image_loader" ||
  ! grep -Fq "{ [weak self] data, response, error in" "$image_loader" ||
  ! grep -Fq "guard let self = self else { return }" "$image_loader" ||
  grep -Fq "let task = URLSession.shared.dataTask" "$image_loader" ||
  grep -Fq "load(urlString: self.url)" "$image_loader"; then
  printf '%s\n' "ImageLoader must require HTTPS URLs with hosts, cancel retained tasks, avoid strong task captures, and avoid recursive reloads when data changes." >&2
  exit 1
fi

if ! grep -Fq "fetcher.errorMessage" "$ROOT_DIR/FSQNearby/View/VenueListView.swift" ||
  ! grep -Fq "No venues found." "$ROOT_DIR/FSQNearby/View/VenueListView.swift"; then
  printf '%s\n' "VenueListView must expose error and empty states." >&2
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
  ! grep -Fq "weak task captures" "$ROOT_DIR/README.md" ||
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
  ! grep -Fq "Image loading retains and cancels URLSession tasks" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "weak task captures" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "FOURSQUARE_VENUE_SEARCH_URL" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current transport baseline." >&2
  exit 1
fi

if ! grep -Fq "Resolved on 2026-06-08" "$ROOT_DIR/docs/bugs/p2-ios-global-ats-bypass-d3b1b3edbda3cef9.md"; then
  printf '%s\n' "ATS bug record must include the local resolution." >&2
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

printf '%s\n' "foursquare-search-swiftui transport baseline checks passed."
