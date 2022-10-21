//
//  UIImage+Extension.swift
//  StudySSE
//
//  Created by 김기림 on 2022/10/21.
//

import UIKit

extension UIImage {
  // 이미지 리사이즈 (메모리 과부하 체크필요)
  func setImgResize(_ newWidth: CGFloat) -> UIImage {
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale
    
    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { context in
      self.draw(in: CGRect(origin: .zero, size: size))
    }
    
    print("화면 배율 \(UIScreen.main.scale)")
    print("origin: \(self), resize: \(renderImage)")
    print("DataSize \(renderImage)")
    
    return renderImage
  }
  
  convenience init?(base64: String, withPrefix: Bool) {
    var finalData: Data?
    
    if withPrefix {
      guard let url = URL(string: base64) else { return nil }
      finalData = try? Data(contentsOf: url)
    } else {
      finalData = Data(base64Encoded: base64)
    }
    
    guard let data = finalData else { return nil }
    self.init(data: data)
  }
  
  // Base64 -> UIImage Convert
  convenience init?(base64String: String) {
    guard let imageData = Data(base64Encoded: base64String) else {
      self.init(base64: base64String, withPrefix: true)
      return
    }
    self.init(data: imageData)
  }
  
  func toBase64String() -> String? {
    return self.jpegData(compressionQuality: 1.0)?.base64EncodedString()
  }
  
  // 이미지 회전
  func rotateImage() -> UIImage {
    if self.imageOrientation == UIImage.Orientation.up {
      return self
    }
    UIGraphicsBeginImageContext(self.size)
    self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
    let copy = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    if let copy = copy {
      return copy
    }
    return self
  }
}
