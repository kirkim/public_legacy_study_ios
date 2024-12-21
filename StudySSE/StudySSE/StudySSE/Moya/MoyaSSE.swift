//
//  MoyaSSE.swift
//  StudySSE
//
//  Created by 김기림 on 2022/10/21.
//

import Moya

public enum MoyaSSE {
  case model1(targetImageData: Data, imageID: String)
}

// MARK: TotalRepository+TargetType
extension MoyaSSE: TargetType {
  public var baseURL: URL { self.getBaseURL() }
  public var path: String { self.getPath() }
  public var method: Method { self.getMethod() }
  public var sampleData: Data { Data() }
  public var task: Task { self.getTask() }
  public var headers: [String : String]? {
      [
        "Content-Type": "multipart/form-data",
      ]
  }
}

extension MoyaSSE {
  func getBaseURL() -> URL {
    switch self {
    case .model1:
      return URL(string: "http://15.164.231.245:8080/")!
    }
  }
}

extension MoyaSSE {
  func getMethod() -> Moya.Method {
    switch self {
    case .model1:
      return .post
    }
  }
}

extension MoyaSSE {
  func getPath() -> String {
    switch self {
    case .model1:
      return "anime"
    }
  }
}

extension MoyaSSE {
  func getTask() -> Task {
    switch self {
    case let .model1(targetImageData: targetImg, imageID: imageID):
      return .uploadMultipart(formData(targetImg, imageID))
    }
  }
  
  private func formData(_ targetImageData: Data, _ imageID: String) -> [MultipartFormData] {
    var result = [Moya.MultipartFormData]()
    
    result.append(
      MultipartFormData(
        provider: .data(targetImageData),
        name: "image",
        fileName: "img.jpeg",
        mimeType: "image/jpeg"
      )
    )
    result.append(
      MultipartFormData(
        provider: .data(imageID.data(using: .utf8)!),
        name: "imageID"
      )
    )
    
    return result
  }
}
