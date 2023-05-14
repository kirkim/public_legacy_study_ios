//
//  ContentView.swift
//  MetalMaster
//
//  Created by 김기림 on 2023/04/25.
//

import SwiftUI
import MetalKit

struct ContentView: UIViewRepresentable {
    
    func makeCoordinator() -> Renderer {
        Renderer(self)
    }
    
//    func makeUIView(context: UIViewControllerRepresentableContext<ContentView>) -> MTKView
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        
        return mtkView
    }
    
//    func updateUIView(_ uiView: MTKView, context: UIViewControllerRepresentableContext<ContentView>) {
    func updateUIView(_ uiView: MTKView, context: Context) {
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
