#!/usr/bin/env python3
import argparse
from pathlib import Path


def validate(content_view: str, venue_list: str, project: str) -> None:
    required_content = (
        "private let venueFetcher: VenueFetcher",
        "init(venueFetcher: VenueFetcher = VenueFetcher())",
        "self.venueFetcher = venueFetcher",
        "VenueListView(fetcher: venueFetcher)",
    )
    if any(contract not in content_view for contract in required_content):
        raise ValueError("ContentView must own and inject one venue fetcher.")
    if "@ObservedObject var fetcher: VenueFetcher" not in venue_list:
        raise ValueError("VenueListView must observe its injected venue fetcher.")
    if "@ObservedObject var fetcher = VenueFetcher()" in venue_list:
        raise ValueError("VenueListView must not construct a venue fetcher.")
    if "IPHONEOS_DEPLOYMENT_TARGET = 13.2;" not in project:
        raise ValueError("Venue fetcher ownership must preserve the iOS 13.2 target.")
    if "@StateObject" in content_view or "@StateObject" in venue_list:
        raise ValueError("The iOS 13.2 target cannot rely on StateObject.")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mutation-test", action="store_true")
    args = parser.parse_args()

    root = Path(__file__).resolve().parent.parent
    content_view = (root / "FSQNearby/ContentView.swift").read_text()
    venue_list = (root / "FSQNearby/View/VenueListView.swift").read_text()
    project = (root / "FSQNearby.xcodeproj/project.pbxproj").read_text()

    if args.mutation_test:
        mutated_content = content_view.replace(
            "VenueListView(fetcher: venueFetcher)", "VenueListView()"
        )
        mutated_list = venue_list.replace(
            "@ObservedObject var fetcher: VenueFetcher",
            "@ObservedObject var fetcher = VenueFetcher()",
        )
        if mutated_content == content_view or mutated_list == venue_list:
            raise SystemExit("Venue fetcher ownership mutation target was not found.")
        try:
            validate(mutated_content, mutated_list, project)
        except ValueError:
            print("Venue fetcher ownership mutation rejected.")
            return
        raise SystemExit("Venue fetcher ownership mutation was not rejected.")

    try:
        validate(content_view, venue_list, project)
    except ValueError as error:
        raise SystemExit(str(error)) from error
    print("Venue fetcher ownership checks passed.")


if __name__ == "__main__":
    main()
