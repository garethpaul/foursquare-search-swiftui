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
        List {
            ForEach(fetcher.venues) { v in
                VenueItemView(venue: v)
                    .frame(height: 100, alignment: .leading)
            }
        }
    }
}
