#!/usr/bin/env python3
from pathlib import Path
import sys


venue = Path(sys.argv[1]).read_text(encoding="utf-8")
image = Path(sys.argv[2]).read_text(encoding="utf-8")

venue_init = venue.split("    init() {", 1)[1].split("\n    deinit", 1)[0]
venue_contracts = (
    "let sessionDelegate = VenueRedirectRejectingDelegate()",
    "let configuration = URLSessionConfiguration.default",
    "configuration.timeoutIntervalForRequest = 15.0",
    "configuration.timeoutIntervalForResource = 30.0",
    "self.sessionDelegate = sessionDelegate",
    "self.venueSession = URLSession(",
    "configuration: configuration",
    "delegate: sessionDelegate",
)
for contract in venue_contracts:
    if venue_init.count(contract) != 1:
        raise SystemExit(f"Venue session initializer must contain one {contract!r}.")
if not all(venue_init.index(a) < venue_init.index(b) for a, b in zip(venue_contracts, venue_contracts[1:])):
    raise SystemExit("Venue timeouts must precede dedicated session construction.")
if "configuration: .default" in venue_init:
    raise SystemExit("Venue networking must not bypass the bounded configuration.")

for contract in (
    "private let imageSession: URLSession",
    "imageSession.invalidateAndCancel()",
    "task = imageSession.downloadTask(with: url)",
):
    if image.count(contract) != 1:
        raise SystemExit(f"Image session lifecycle must contain one {contract!r}.")
if "URLSession.shared.downloadTask" in image:
    raise SystemExit("Image networking must not fall back to URLSession.shared.")

image_init = image.split("    init(urlString:String) {", 1)[1].split("\n    deinit", 1)[0]
image_contracts = (
    "let sessionDelegate = ImageRedirectRejectingDelegate()",
    "let configuration = URLSessionConfiguration.default",
    "configuration.timeoutIntervalForRequest = 15.0",
    "configuration.timeoutIntervalForResource = 30.0",
    "self.sessionDelegate = sessionDelegate",
    "self.imageSession = URLSession(",
    "configuration: configuration",
    "delegate: sessionDelegate",
    "self.url = urlString",
    "load(urlString: url)",
)
for contract in image_contracts:
    if image_init.count(contract) != 1:
        raise SystemExit(f"Image session initializer must contain one {contract!r}.")
if not all(image_init.index(a) < image_init.index(b) for a, b in zip(image_contracts, image_contracts[1:])):
    raise SystemExit("Image timeouts and session ownership must precede request loading.")

image_deinit = image.split("    deinit {", 1)[1].split("\n    private func load", 1)[0]
if not (
    image_deinit.count("task?.cancel()") == 1
    and image_deinit.count("imageSession.invalidateAndCancel()") == 1
    and image_deinit.index("task?.cancel()") < image_deinit.index("imageSession.invalidateAndCancel()")
):
    raise SystemExit("Image loader must cancel its task before invalidating its session.")

print("SwiftUI network timeout checks passed.")
