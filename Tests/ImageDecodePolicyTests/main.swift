import Foundation

private var failureCount = 0

private func expect(_ condition: Bool, _ message: String) {
    if !condition {
        failureCount += 1
        print("FAIL: \(message)")
    }
}

let onePixelPNG = Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/p9sAAAAASUVORK5CYII=")!
let randomBytes = Data([0x00, 0x11, 0x22, 0x33, 0x44])

expect(ImageDecodePolicy.accepts(pixelWidth: 64, pixelHeight: 64), "ordinary icon dimensions should be accepted")
expect(ImageDecodePolicy.accepts(pixelWidth: 2_000, pixelHeight: 2_000), "bounded large image should be accepted")
expect(!ImageDecodePolicy.accepts(pixelWidth: nil, pixelHeight: 64), "missing width should be rejected")
expect(!ImageDecodePolicy.accepts(pixelWidth: 64, pixelHeight: nil), "missing height should be rejected")
expect(!ImageDecodePolicy.accepts(pixelWidth: 0, pixelHeight: 64), "zero width should be rejected")
expect(!ImageDecodePolicy.accepts(pixelWidth: 64, pixelHeight: 0), "zero height should be rejected")
expect(!ImageDecodePolicy.accepts(pixelWidth: 4_097, pixelHeight: 1), "oversized width should be rejected")
expect(!ImageDecodePolicy.accepts(pixelWidth: 1, pixelHeight: 4_097), "oversized height should be rejected")
expect(!ImageDecodePolicy.accepts(pixelWidth: 2_000, pixelHeight: 2_001), "decoded pixel budget should be enforced")
expect(ImageDecodePolicy.acceptsImageData(onePixelPNG), "valid tiny PNG data should be accepted")
expect(!ImageDecodePolicy.acceptsImageData(randomBytes), "non-image data should be rejected")
expect(!ImageDecodePolicy.acceptsImageData(Data()), "empty image data should be rejected")

if failureCount > 0 {
    exit(1)
}

print("ImageDecodePolicy behavioral tests passed")
