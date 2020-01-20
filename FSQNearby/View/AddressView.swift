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
            if location.address != nil {
                Text(location.address!)
            }
            if location.city != nil {
                Text(location.city!)
            }
            if location.country != nil {
                Text(location.country!)
            }
        }.font(.system(size: 10))
         .frame(alignment: .leading)

    }
}
