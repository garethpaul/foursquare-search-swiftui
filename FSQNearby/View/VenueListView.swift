//
//  VenueListView.swift
//  FSQNearby
//
//  Created by GPJ on 1/19/20.
//  Copyright © 2020 GPJ. All rights reserved.
//

import SwiftUI

struct VenueListView: View {
    @ObservedObject var fetcher = VenueFetcher()
    
    var body: some View {
        Group {
            if let message = fetcher.errorMessage {
                Text(message)
                    .foregroundColor(.secondary)
            } else if fetcher.venues.isEmpty {
                Text("No venues found.")
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(fetcher.venues) { v in
                        VenueItemView(venue: v)
                            .frame(height: 100, alignment: .leading)
                    }
                }
            }
        }
    }
}
