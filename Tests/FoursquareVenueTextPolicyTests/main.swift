import Foundation

private var failureCount = 0

private func expectName(_ value: String, normalized expected: String?, _ message: String) {
    let actual = FoursquareVenueTextPolicy.normalizedName(value)
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(String(describing: expected)), got \(String(describing: actual))")
    }
}

private func expectDisplayName(_ value: String, expected: String, _ message: String) {
    let actual = FoursquareVenueTextPolicy.displayName(value)
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expectName("Coffee Shop", normalized: "Coffee Shop", "ordinary name")
expectName("  Coffee Shop\n", normalized: "Coffee Shop", "surrounding whitespace")
expectName("", normalized: nil, "empty name")
expectName(" \t\n ", normalized: nil, "whitespace-only name")
expectName("  Café 東京  ", normalized: "Café 東京", "Unicode name")
expectDisplayName("  Coffee Shop  ", expected: "Coffee Shop", "normalized display name")
expectDisplayName("\n", expected: "Venue", "defensive display fallback")

if failureCount > 0 {
    exit(1)
}

print("FoursquareVenueTextPolicy behavioral tests passed")
