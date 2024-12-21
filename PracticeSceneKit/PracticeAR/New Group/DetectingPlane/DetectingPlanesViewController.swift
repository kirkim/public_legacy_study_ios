//
//  ViewController1.swift
//  PracticeAR
//
//  Created by 김기림 on 2022/10/01.
//

import UIKit
import SceneKit
import ARKit

class DetectingPlanesViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    private let label:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView.debugOptions =
        [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin] // x,y,z와 특징점을 보여줌
        
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        configureLayout()
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            self.label.text = "Plane Detected"
            
            UIView.animate(withDuration: 3.0) {
                self.label.alpha = 1.0
            } completion: { _ in
                self.label.alpha = 0.0
            }

        }
    }
    
    func configureLayout() {
        self.view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}
