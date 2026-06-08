//
//  CategoryIconView.swift
//  FSQNearby
//
//  Created by GPJ on 1/19/20.
//  Copyright © 2020 GPJ. All rights reserved.
//

import SwiftUI

struct CategoryIconView: View {
    let categories: [Category]
    
    var body: some View {
        VStack(){
            if let iconPrefix = categories.first?.icon?.iconPrefix {
                IconView(withURL: iconPrefix + "64.png")
            }
        }
    }
}
