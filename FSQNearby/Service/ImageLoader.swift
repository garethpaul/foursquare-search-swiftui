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
    private var url: String = ""
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
    
    private func load(urlString:String) {
        guard let url = URL(string: urlString),
            url.scheme == "https",
            url.host?.isEmpty == false else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let data = data else { return }

            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
