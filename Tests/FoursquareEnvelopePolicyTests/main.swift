import Foundation

private var failureCount = 0

private func expect(
    metaCode: Int?,
    hasResponse: Bool,
    accepted expected: Bool,
    _ message: String
) {
    let actual = FoursquareEnvelopePolicy.accepts(
        metaCode: metaCode,
        hasResponse: hasResponse
    )
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expect(metaCode: 200, hasResponse: true, accepted: true, "successful envelope")
expect(metaCode: nil, hasResponse: true, accepted: false, "missing meta code")
expect(metaCode: 400, hasResponse: true, accepted: false, "client error envelope")
expect(metaCode: 500, hasResponse: true, accepted: false, "server error envelope")
expect(metaCode: 200, hasResponse: false, accepted: false, "missing response")
expect(metaCode: nil, hasResponse: false, accepted: false, "missing envelope fields")

if failureCount > 0 {
    exit(1)
}

print("FoursquareEnvelopePolicy behavioral tests passed")
