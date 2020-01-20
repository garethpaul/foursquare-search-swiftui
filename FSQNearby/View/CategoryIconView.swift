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
            if categories.first != nil {
                IconView(withURL: (categories.first!.icon?.iconPrefix)! + "64.png")
            }
        }
    }
}
