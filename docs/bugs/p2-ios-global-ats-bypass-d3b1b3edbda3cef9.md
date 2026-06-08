# [P2] Remove the global iOS App Transport Security bypass

## Severity

P2 - security/transport

## Evidence

- `FSQNearby/Info.plist:54`: `<key>NSAllowsArbitraryLoads</key>`
- `FSQNearby/Info.plist:55`: `<true/>`
- `FSQNearby/Service/ImageLoader.swift:30`: `let task = URLSession.shared.dataTask(with: url) { data, response, error in`
- `FSQNearby/Service/VenueFetcher.swift:21`: `URLSession.shared.dataTask(with: url) {(data,response,error) in`

## Problem

The app sets `NSAllowsArbitraryLoads` to true, disabling iOS App Transport Security for every outbound connection. Any missed plain-HTTP URL can transmit traffic without TLS and bypass the platform's normal transport protections.

## Suggested fix

Remove the global `NSAllowsArbitraryLoads` setting, use HTTPS endpoints for network calls, and if an exception is unavoidable, scope it to the specific domain with `NSExceptionDomains` instead of disabling ATS app-wide.

## Resolution

Resolved on 2026-06-08 by removing the global ATS bypass, requiring the
venue-search endpoint to come from the local `FOURSQUARE_VENUE_SEARCH_URL`
build setting, and adding `make check` coverage for transport guardrails.

## Review metadata

- Repository: `garethpaul/foursquare-search-swiftui`
- Reviewed commit: `7957d7216e4ba9616a0150754c09c68f54f1703e`
- Labels: `bug`, `codex-review`, `severity:P2`
- Codex review fingerprint: `d3b1b3edbda3cef9`
