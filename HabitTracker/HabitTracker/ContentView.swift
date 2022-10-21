//
//  ContentView.swift
//  HabitTracker
//
//  Created by 전지훈 on 2022/10/21.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
