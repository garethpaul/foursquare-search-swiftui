import Foundation

enum FoursquareEnvelopePolicy {
    static func accepts(metaCode: Int?, hasResponse: Bool) -> Bool {
        return metaCode == 200 && hasResponse
    }
}
