//
//  VenueFetcher.swift
//  FSQNearby
//
//  Created by GPJ on 1/19/20.
//  Copyright © 2020 GPJ. All rights reserved.
//

import Foundation

public class VenueFetcher: ObservableObject {
    private let maxVenuePayloadBytes = 2 * 1024 * 1024
    @Published var venues = [Venue]()
    @Published var errorMessage: String?
    private var task: URLSessionDownloadTask?
    
    init() {
        load()
    }

    deinit {
        task?.cancel()
    }
    
    private func load() {
        guard let url = venueSearchURL() else {
            setError("Venue search is not configured.")
            return
        }

        task = URLSession.shared.downloadTask(with: url) { [weak self] location, response, error in
            guard let self = self else { return }

            if error != nil {
                self.setError("Unable to load venues.")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                self.isJSONResponse(httpResponse),
                httpResponse.expectedContentLength < 0 ||
                    httpResponse.expectedContentLength <= Int64(self.maxVenuePayloadBytes),
                let location = location,
                let attributes = try? FileManager.default.attributesOfItem(atPath: location.path),
                let fileSize = attributes[.size] as? NSNumber,
                fileSize.intValue > 0,
                fileSize.intValue <= self.maxVenuePayloadBytes,
                let data = try? Data(contentsOf: location),
                !data.isEmpty,
                data.count <= self.maxVenuePayloadBytes else {
                self.setError("Venue search returned no data.")
                return
            }

            do {
                let foursquareSearch = try JSONDecoder().decode(FoursquareSearch.self, from: data)
                let venues = foursquareSearch.response?.venues ?? []
                DispatchQueue.main.async {
                    self.errorMessage = venues.isEmpty ? "No venues found." : nil
                    self.venues = venues
                }
            } catch {
                self.setError("Unable to decode venue search results.")
            }
        }
        task?.resume()
    }

    private func isJSONResponse(_ response: HTTPURLResponse) -> Bool {
        guard let contentType = response.value(forHTTPHeaderField: "Content-Type"),
            let mediaType = contentType.split(separator: ";", maxSplits: 1).first?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased() else {
            return false
        }

        return mediaType == "application/json" ||
            (mediaType.hasPrefix("application/") && mediaType.hasSuffix("+json"))
    }

    private func venueSearchURL() -> URL? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "FoursquareVenueSearchURL") as? String else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty,
            !trimmedValue.contains("$("),
            let url = URL(string: trimmedValue),
            url.scheme == "https",
            url.host?.isEmpty == false,
            url.user == nil,
            url.password == nil,
            url.fragment == nil else {
            return nil
        }

        return url
    }

    private func setError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.venues = []
        }
    }
}
