//
//  RemoteViewController.swift
//  PracticeAR
//
//  Created by 김기림 on 2022/10/01.
//

import UIKit

class RemoteViewController: UIViewController {
    
    @IBAction func handleFirstCase(_ sender: Any) {
//        let nib = UINib(nibName: "ViewController1", bundle: nil)
        let vc = DetectingPlanesViewController(nibName: "DetectingPlanesViewController", bundle: nil)
        self.present(vc, animated: true)
    }
    
    @IBAction func handleOverlayingPlanes(_ sender: Any) {
        
    }
}

