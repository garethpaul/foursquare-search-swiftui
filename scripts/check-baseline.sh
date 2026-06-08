#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-foursquare-search-swiftui-transport-baseline.md"

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
  "docs/plans/2026-06-08-foursquare-search-swiftui-transport-baseline.md"; do
  require_file "$path"
done

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
  ! grep -Fq 'errorMessage' "$venue" ||
  grep -Fq 'URL(string: "FOURSQUARE_VENUE_SEARCH")!' "$venue" ||
  grep -Eq 'responseData\?\.(venues)\)!|URL\(string:.*\)!|print\(' "$venue"; then
  printf '%s\n' "VenueFetcher must use local HTTPS configuration without force unwraps or print diagnostics." >&2
  exit 1
fi

image_loader="$ROOT_DIR/FSQNearby/Service/ImageLoader.swift"
if ! grep -Fq 'url.scheme == "https"' "$image_loader" ||
  grep -Fq "load(urlString: self.url)" "$image_loader"; then
  printf '%s\n' "ImageLoader must require HTTPS and avoid recursive reloads when data changes." >&2
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
  ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "App Transport Security" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document local endpoint configuration and verification." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "NSAllowsArbitraryLoads" "$ROOT_DIR/VISION.md" ||
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

printf '%s\n' "foursquare-search-swiftui transport baseline checks passed."
