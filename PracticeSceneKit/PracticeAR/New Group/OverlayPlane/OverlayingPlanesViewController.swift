//
//  OverlayingPlanesViewController.swift
//  PracticeAR
//
//  Created by 김기림 on 2022/10/01.
//

import UIKit
import SceneKit
import ARKit

class OverlayingPlanesViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = ARSCNView(frame: self.view.frame)
        
        self.sceneView.debugOptions =
        [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin] // x,y,z와 특징점을 보여줌
        
        self.view.addSubview(sceneView)
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
}
