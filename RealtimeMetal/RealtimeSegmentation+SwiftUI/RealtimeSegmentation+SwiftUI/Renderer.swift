//
//  Renderer.swift
//  RealtimeSegmentation+SwiftUI
//
//  Created by 김기림 on 2023/05/08.
//

import MetalKit
import SwiftUI

final class Renderer: NSObject, ObservableObject, MTKViewDelegate {
    
    @Binding var currentCIImage: CIImage
    private let metalCommandQueue: MTLCommandQueue
    private let metalDevice: MTLDevice
    private let ciContext: CIContext
    
    init?(currentCIImage: Binding<CIImage>) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let queue = device.makeCommandQueue() else {
            return
        }
        self.metalDevice = device
        self._currentCIImage = currentCIImage
        self.metalCommandQueue = queue
        self.ciContext = CIContext(mtlDevice: device)
    }
    
    func draw(in view: MTKView) {
        // grab command buffer so we can encode instructions to GPU
        guard let commandBuffer = metalCommandQueue.makeCommandBuffer() else {
            return
        }

        // grab image
        guard let ciImage = currentCIImage else {
            return
        }

        // ensure drawable is free and not tied in the preivous drawing cycle
        guard let currentDrawable = view.currentDrawable else {
            return
        }
        
        // make sure the image is full screen
        let drawSize = cameraView.drawableSize
        let scaleX = drawSize.width / ciImage.extent.width
        let scaleY = drawSize.height / ciImage.extent.height
        
        let newImage = ciImage.transformed(by: .init(scaleX: scaleX, y: scaleY))
        //render into the metal texture
        self.ciContext.render(newImage,
                              to: currentDrawable.texture,
                              commandBuffer: commandBuffer,
                              bounds: newImage.extent,
                              colorSpace: CGColorSpaceCreateDeviceRGB())

        // register drawwable to command buffer
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Delegate method not implemented.
    }
    
}
