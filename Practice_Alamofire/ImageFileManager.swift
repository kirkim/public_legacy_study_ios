//
//  FileManager.swift
//  Practice_Alamofire
//
//  Created by 김기림 on 2022/08/13.
//

import UIKit

final class ImageFileManager {
    private let filenameExtension = ".png"
    static let shared = ImageFileManager()
    private init() { }
    
    private let fileManager = FileManager.default
    private let documentPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func saveImageByURL(imageURL: String?, id: UUID, completion: @escaping (Result<String,DBManagerError>) -> ()) {
        guard let urlString = imageURL else {
            completion(.failure(.badURL))
            return
        }
        let filename = id.uuidString
        let cachedImage = ImageCacheManager.shared.cachedImage(urlString: urlString)
        if cachedImage != nil {
            guard let result = saveImage(filename: filename, image: cachedImage) else {
                completion(.failure(.failToSaveImageFile))
                return
            }
            completion(.success(result))
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil,
                    let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError))
                return
            }
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                completion(.failure(.failParsingToImage))
                return
            }
            ImageCacheManager.shared.setObject(image: image, urlString: urlString)
            guard let result = self?.saveImage(filename: filename, image: image) else {
                completion(.failure(.failToSaveImageFile))
                return }
            completion(.success(result))
        }.resume()
    }
    
    func saveImage(filename: String, image: UIImage?) -> String? {
        guard let image = image else {
            return nil
        }
        guard let imageData = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return nil }
        do {
            try imageData.write(to: documentPath.appendingPathComponent(filename + filenameExtension))
            let locationString = filename + filenameExtension
            return locationString
        } catch {
            print(error)
            return nil
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        let result = UIImage(contentsOfFile: URL(fileURLWithPath: documentPath.absoluteString).appendingPathComponent(named).path)
        return result
    }
    
    func removeImage(at filename: String) throws {
        do {
            let urlString = documentPath.absoluteString + filename
            let url = URL(string: urlString)!
            try fileManager.removeItem(at: url)
        } catch {
            throw DBManagerError.failToRemoveImageFile
        }
    }
}
