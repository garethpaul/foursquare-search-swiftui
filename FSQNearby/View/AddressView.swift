//
//  AddressView.swift
//  FSQNearby
//
//  Created by GPJ on 1/19/20.
//  Copyright © 2020 GPJ. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    let location: Location
    var body: some View {
        VStack() {
            if let address = location.address {
                Text(address)
            }
            if let city = location.city {
                Text(city)
            }
            if let country = location.country {
                Text(country)
            }
        }.font(.system(size: 10))
         .frame(alignment: .leading)

    }
}
