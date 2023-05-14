//
//  MetalView.swift
//  RealtimeSegmentation+SwiftUI
//
//  Created by 김기림 on 2023/05/01.
//

import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    
    @State var currentCIImage: CIImage
    @StateObject var renderer: Renderer?
    
    init?() {
        guard let renderer = Renderer(currentCIImage: $currentCIImage) else {
            return
        }
        self.renderer = renderer
    }
    
    func makeCoordinator() -> Renderer {
        return renderer
    }
    
//    func makeUIView(context: UIViewControllerRepresentableContext<ContentView>) -> MTKView
    func makeUIView(context: Context) -> MTKView {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            return mtkView
        }
        mtkView.device = metalDevice
        mtkView.isPaused = true
        mtkView.enableSetNeedsDisplay = false
        mtkView.framebufferOnly = false
        
        return mtkView
    }
    
//    func updateUIView(_ uiView: MTKView, context: UIViewControllerRepresentableContext<ContentView>) {
    func updateUIView(_ uiView: MTKView, context: Context) {
    }
    
}
