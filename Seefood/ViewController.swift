//
//  ViewController.swift
//  Seefood
//
//  Created by 김기림 on 2022/09/13.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true)
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard error == nil,
                  let results = request.results as? [VNClassificationObservation] else {
                fatalError("Mdoel failed to process image.")
            }
        
            if let firstResult = results.first {
                print(firstResult)
                let percentage = String(round(firstResult.confidence*1000)/10) + "%"
                let name = firstResult.identifier
                self.navigationItem.title = percentage + "  " + name
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

