/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app shows how to use Vision person segmentation and detect face
 to perform realtime image masking effects.
*/

import UIKit
import Vision
import MetalKit
import AVFoundation
import CoreImage.CIFilterBuiltins



final class ViewController: UIViewController {
    
    // The Vision requests and the handler to perform them.
    private let requestHandler = VNSequenceRequestHandler()
    private var facePoseRequest: VNDetectFaceRectanglesRequest!
    private var segmentationRequest = VNGeneratePersonSegmentationRequest()
    
    // A structure that contains RGB color intensity values.
    private var colors: AngleColors?
    
    private var cameraView: MTKView! {
        didSet {
            guard metalDevice == nil else { return }
            setupMetal()
            setupCoreImage()
            setupCaptureSession()
        }
    }
    
    // The Metal pipeline.
    public var metalDevice: MTLDevice!
    public var metalCommandQueue: MTLCommandQueue!
    
    // The Core Image pipeline.
    public var ciContext: CIContext!
    public var currentCIImage: CIImage? {
        didSet {
            cameraView.draw()
        }
    }
    
    // The capture session that provides video frames.
    public var session: AVCaptureSession?
    
    // MARK: - ViewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui()
        intializeRequests()
    }
    
    deinit {
        session?.stopRunning()
    }
    
    private func ui() {
        let mtview = MTKView()
        mtview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mtview)
        mtview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mtview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mtview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mtview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cameraView = mtview
    }
    
    // MARK: - Prepare Requests
    
    private func intializeRequests() {
        
        // Create a request to detect face rectangles.
        facePoseRequest = VNDetectFaceRectanglesRequest { [weak self] request, _ in
            guard let face = request.results?.first as? VNFaceObservation else { return }
            // Generate RGB color intensity values for the face rectangle angles.
            self?.colors = AngleColors(roll: face.roll, pitch: face.pitch, yaw: face.yaw)
        }
        facePoseRequest.revision = VNDetectFaceRectanglesRequestRevision3
        
        // Create a request to segment a person from an image.
        segmentationRequest = VNGeneratePersonSegmentationRequest()
        segmentationRequest.qualityLevel = .balanced
        segmentationRequest.outputPixelFormat = kCVPixelFormatType_OneComponent8
    }
    
    // MARK: - Perform Requests
    
    private func processVideoFrame(_ framePixelBuffer: CVPixelBuffer) {
        // Perform the requests on the pixel buffer that contains the video frame.
        try? requestHandler.perform([facePoseRequest, segmentationRequest],
                                    on: framePixelBuffer,
                                    orientation: .right)
        
        // Get the pixel buffer that contains the mask image.
        guard let maskPixelBuffer =
                segmentationRequest.results?.first?.pixelBuffer else { return }
        
        // Process the images.
        blend(original: framePixelBuffer, mask: maskPixelBuffer)
    }
    
    // MARK: - Process Results
    
    // Performs the blend operation.
    private func blend(original framePixelBuffer: CVPixelBuffer,
                       mask maskPixelBuffer: CVPixelBuffer) {
        
        // Remove the optionality from generated color intensities or exit early.
        guard let colors = colors else { return }
        
        // Create CIImage objects for the video frame and the segmentation mask.
        let originalImage = CIImage(cvPixelBuffer: framePixelBuffer).oriented(.right)
        var maskImage = CIImage(cvPixelBuffer: maskPixelBuffer)
        
        // Scale the mask image to fit the bounds of the video frame.
        let scaleX = originalImage.extent.width / maskImage.extent.width
        let scaleY = originalImage.extent.height / maskImage.extent.height
        maskImage = maskImage.transformed(by: .init(scaleX: scaleX, y: scaleY))
        
        // Define RGB vectors for CIColorMatrix filter.
        let vectors = [
            "inputRVector": CIVector(x: 0, y: 0, z: 0, w: colors.red),
            "inputGVector": CIVector(x: 0, y: 0, z: 0, w: colors.green),
            "inputBVector": CIVector(x: 0, y: 0, z: 0, w: colors.blue)
        ]
        
        // Create a colored background image.
        let backgroundImage = maskImage.applyingFilter("CIColorMatrix",
                                                       parameters: vectors)
        
        // Blend the original, background, and mask images.
        let blendFilter = CIFilter.blendWithRedMask()
        blendFilter.inputImage = originalImage
        blendFilter.backgroundImage = backgroundImage
        blendFilter.maskImage = maskImage
        
        // Set the new, blended image as current.
        currentCIImage = blendFilter.outputImage?.oriented(.left)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Grab the pixelbuffer frame from the camera output
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        processVideoFrame(pixelBuffer)
    }
}

extension ViewController {
    
    func setupMetal() {
        metalDevice = MTLCreateSystemDefaultDevice()
        metalCommandQueue = metalDevice.makeCommandQueue()
        
        cameraView.device = metalDevice
        cameraView.isPaused = true
        cameraView.enableSetNeedsDisplay = false
        cameraView.delegate = self
        cameraView.framebufferOnly = false
    }
    
    func setupCoreImage() {
        ciContext = CIContext(mtlDevice: metalDevice)
    }
    
    func setupCaptureSession() {
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            fatalError("Error getting AVCaptureDevice.")
        }
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            fatalError("Error getting AVCaptureDeviceInput")
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.session = AVCaptureSession()
            self.session?.sessionPreset = .high
            self.session?.addInput(input)
            
            let output = AVCaptureVideoDataOutput()
            output.alwaysDiscardsLateVideoFrames = true
            output.setSampleBufferDelegate(self, queue: .main)
            
            self.session?.addOutput(output)
            output.connections.first?.videoOrientation = .portrait
            self.session?.startRunning()
        }
    }
    
}

/// A structure that provides an RGB color intensity value for the roll, pitch, and yaw angles.
fileprivate struct AngleColors {
    
    let red: CGFloat
    let blue: CGFloat
    let green: CGFloat
    
    init(roll: NSNumber?, pitch: NSNumber?, yaw: NSNumber?) {
        red = AngleColors.convert(value: roll, with: -.pi, and: .pi)
        blue = AngleColors.convert(value: pitch, with: -.pi / 2, and: .pi / 2)
        green = AngleColors.convert(value: yaw, with: -.pi / 2, and: .pi / 2)
    }
    
    static func convert(value: NSNumber?, with minValue: CGFloat, and maxValue: CGFloat) -> CGFloat {
        guard let value = value else { return 0 }
        let maxValue = maxValue * 0.8
        let minValue = minValue + (maxValue * 0.2)
        let facePoseRange = maxValue - minValue
        
        guard facePoseRange != 0 else { return 0 } // protect from zero division
        
        let colorRange: CGFloat = 1
        return (((CGFloat(truncating: value) - minValue) * colorRange) / facePoseRange)
    }
    
}

extension ViewController: MTKViewDelegate {
    
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

