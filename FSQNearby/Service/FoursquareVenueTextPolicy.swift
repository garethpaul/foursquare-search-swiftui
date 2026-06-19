import Foundation

enum FoursquareVenueTextPolicy {
    static func normalizedName(_ value: String) -> String? {
        let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized.isEmpty ? nil : normalized
    }

    static func displayName(_ value: String) -> String {
        return normalizedName(value) ?? "Venue"
    }
}
