//
//  ImageLoader.swift
//  FSQNearby
//
//  Created by GPJ on 1/19/20.
//  Copyright © 2020 GPJ. All rights reserved.
//

import Combine
import Foundation

class ImageLoader: ObservableObject {
    private let maxImagePayloadBytes = 5 * 1024 * 1024
    private var url: String = ""
    private var task: URLSessionDownloadTask?
    var didChange = PassthroughSubject<Data, Never>()
    
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        self.url = urlString
        load(urlString: url)
    }

    deinit {
        task?.cancel()
    }
    
    private func load(urlString:String) {
        guard let url = URL(string: urlString),
            url.scheme == "https",
            url.host?.isEmpty == false,
            url.user == nil,
            url.password == nil,
            url.fragment == nil else { return }
        task = URLSession.shared.downloadTask(with: url) { [weak self] location, response, error in
            guard let self = self else { return }
            guard error == nil,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                httpResponse.expectedContentLength < 0 ||
                    httpResponse.expectedContentLength <= Int64(self.maxImagePayloadBytes),
                let location = location,
                let attributes = try? FileManager.default.attributesOfItem(atPath: location.path),
                let fileSize = attributes[.size] as? NSNumber,
                fileSize.intValue > 0,
                fileSize.intValue <= self.maxImagePayloadBytes,
                let data = try? Data(contentsOf: location),
                !data.isEmpty,
                data.count <= self.maxImagePayloadBytes else { return }

            DispatchQueue.main.async {
                self.data = data
            }
        }
        task?.resume()
    }
}
