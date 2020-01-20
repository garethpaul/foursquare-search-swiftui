//
//  VenueFetcher.swift
//  FSQNearby
//
//  Created by GPJ on 1/19/20.
//  Copyright © 2020 GPJ. All rights reserved.
//

import Foundation

public class VenueFetcher: ObservableObject {
    @Published var venues = [Venue]()
    
    init() {
        load()
    }
    
    private func load() {
        let url = URL(string: "FOURSQUARE_VENUE_SEARCH")!
        
            URLSession.shared.dataTask(with: url) {(data,response,error) in
                do {
                    if let d = data {
                        let foursquareSearch = try JSONDecoder().decode(FoursquareSearch.self, from: d)
                        DispatchQueue.main.async {
                            let responseData = foursquareSearch.response
                            self.venues = (responseData?.venues)!
                            print(self.venues)
                        }
                    } else {
                        print("No Data")
                    }
                } catch {
                    print(error)
                    print ("Error: " + error.localizedDescription)
                }
                    

                
            }.resume()
    }
}
