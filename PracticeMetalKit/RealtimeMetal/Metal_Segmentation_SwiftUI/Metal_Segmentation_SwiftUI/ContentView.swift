//
//  ContentView.swift
//  Metal_Segmentation_SwiftUI
//
//  Created by 김기림 on 2023/05/13.
//

import SwiftUI
import MetalKit

struct ContentView: View {
    
    @State var mtkView: MTKView?
    @State var metalView2 = MetalView2()
    
    var body: some View {
        MetalView(mtkView: $mtkView)
//        metalView2
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
