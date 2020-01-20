//
//  VenueItemView.swift
//  FSQNearby
//
//  Created by GPJ on 1/19/20.
//  Copyright © 2020 GPJ. All rights reserved.
//

import SwiftUI

struct VenueItemView: View {
    let venue: Venue
    
    var body: some View {
        
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack(alignment:.leading) {
                    Text(self.venue.name)
                    AddressView(location: self.venue.location)
                }   .frame(width: geometry.size.width / 2, alignment: .leading)
                
                CategoryIconView(categories: self.venue.categories)
                    .frame(width: geometry.size.width / 2)

            }
        }
    }
}
