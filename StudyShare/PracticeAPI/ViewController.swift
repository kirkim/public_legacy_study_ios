//
//  ViewController.swift
//  PracticeAPI
//
//  Created by 김기림 on 2022/10/20.
//

import UIKit
import MessageUI

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    private let mailManager = MailManager()
    
    @IBOutlet weak var sampleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: "sample1")
        폰트확인및적용()
    }
    
    private func 폰트확인및적용() {
        UIFont.familyNames.sorted().forEach { familyName in
            print("*** \(familyName) ***")
            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print("\(fontName)")
            }
            print("---------------------")
        }
        sampleLabel.font = UIFont(name: "MabinogiClassicOTFR", size: 20)
    }
    
    @IBAction func handleShareInsta(_ sender: UIButton) {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                // 위의 sharingImageView의 image를 image에 저장
                guard let image = imageView.image else { return }
                // 지원되는 형식에는 JPG,PNG 가 있다.
                guard let imageData = image.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    // 배경 값 : 두 값이 다르면 그래디언트를 생성
                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
            } else {
                print("User doesn't have instagram on their device.")
            }
        }
    }
    
    @IBAction func handleShareMail(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        mailManager.shareImage(image: image, viewController: self)
    }
    @IBAction func handleSaveInDevice(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
