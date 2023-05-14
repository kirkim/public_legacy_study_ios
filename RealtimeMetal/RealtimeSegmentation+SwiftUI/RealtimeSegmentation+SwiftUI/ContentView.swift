//
//  ContentView.swift
//  RealtimeSegmentation+SwiftUI
//
//  Created by 김기림 on 2023/05/01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MetalView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
