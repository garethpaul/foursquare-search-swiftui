//
//  ContentView.swift
//  FSQNearby
//
//  Created by GPJ on 1/19/20.
//  Copyright © 2020 GPJ. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    private let venueFetcher: VenueFetcher

    init(venueFetcher: VenueFetcher = VenueFetcher()) {
        self.venueFetcher = venueFetcher
    }
 
    var body: some View {
        VStack{
            NavView()
            VenueListView(fetcher: venueFetcher)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
