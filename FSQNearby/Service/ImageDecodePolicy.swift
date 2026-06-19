import Foundation
import ImageIO

enum ImageDecodePolicy {
    static let maxPixelDimension = 4_096
    static let maxDecodedPixels = 4_000_000

    static func acceptsImageData(_ data: Data) -> Bool {
        guard !data.isEmpty,
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else {
            return false
        }

        return accepts(
            pixelWidth: intValue(from: properties[kCGImagePropertyPixelWidth]),
            pixelHeight: intValue(from: properties[kCGImagePropertyPixelHeight])
        )
    }

    static func accepts(pixelWidth: Int?, pixelHeight: Int?) -> Bool {
        guard let pixelWidth = pixelWidth,
            let pixelHeight = pixelHeight,
            pixelWidth > 0,
            pixelHeight > 0,
            pixelWidth <= maxPixelDimension,
            pixelHeight <= maxPixelDimension else {
            return false
        }

        return pixelWidth <= maxDecodedPixels / pixelHeight
    }

    private static func intValue(from value: Any?) -> Int? {
        if let value = value as? Int {
            return value
        }
        return (value as? NSNumber)?.intValue
    }
}
