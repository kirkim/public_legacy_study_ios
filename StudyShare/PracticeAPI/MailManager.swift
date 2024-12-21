//
//  MailManager.swift
//  PracticeAPI
//
//  Created by 김기림 on 2022/10/26.
//

import UIKit
import MessageUI

final class MailManager {
    func shareImage(image: UIImage, viewController: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            let vc = viewController as! MFMailComposeViewControllerDelegate
            composeViewController.mailComposeDelegate = vc
            
            let bodyString = """
                                 Aniface 앱에서 생성되었습니다
                                 
                                 -------------------
                                 
                                 Device Model : \(self.getDeviceIdentifier())
                                 Device OS : \(UIDevice.current.systemVersion)
                                 App Version : \(self.getCurrentVersion())
                                 
                                 -------------------
                                 """
            
            composeViewController.setToRecipients(["modakyi.help@gmail.com"])
            composeViewController.setSubject("Aniface 앱에서 사진을 변환해보세요")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            let jpegData = image.jpegData(compressionQuality: 1.0)!
            composeViewController.addAttachmentData(jpegData, mimeType: "image/jpeg", fileName: "image.jpeg")
            
            viewController.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            viewController.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }

    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
}
