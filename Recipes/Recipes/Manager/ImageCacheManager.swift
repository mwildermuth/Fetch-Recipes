//
//  ImageCacheManager.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/29/25.
//

import UIKit
import SwiftUI

@globalActor actor ImageCacheManager {
    static let shared = ImageCacheManager()
    
    fileprivate let cachePath: URL?
    
    init() {
        let fileManager = FileManager.default
        if let cachePath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let imageDirectoryPath = cachePath.appendingPathComponent("images")

            do {
                if fileManager.fileExists(atPath: imageDirectoryPath.path) == false {
                    try fileManager.createDirectory(at: imageDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                }
                self.cachePath = imageDirectoryPath
            } catch {
                self.cachePath = nil
            }
        } else {
            self.cachePath = nil
        }
    }
    
    func storeImage(url: URL?, image: UIImage) async {
        
        guard let url = url else {
            print("URL not found")
            return
        }
        
        guard let cachePath = cachePath else {
            print("Cache path not found")
            return
        }
        
        let imageFileName = self.getFilename(url: url)
        let imagePath = cachePath.appendingPathComponent(imageFileName)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: imagePath.path) == false {
            if fileManager.createFile(atPath: imagePath.path, contents: image.jpegData(compressionQuality: 1.0)) == false {
                print("Error saving image: \(url.path)")
            }
        } else {
            print("Image already exists: \(url.path)")
        }
    }
    
    func retrieveImage(url: URL?) async -> UIImage? {
        guard let url = url else {
            print("URL not found")
            return nil
        }
        
        guard let cachePath = cachePath else {
            print("Cache path not found")
            return nil
        }
        
        let imageFileName = self.getFilename(url: url)
        let imagePath = cachePath.appendingPathComponent(imageFileName)
        
        let fileManager = FileManager.default
        if let data = fileManager.contents(atPath: imagePath.path) {
            if let uiImage = UIImage(data: data) {
                return uiImage
            }
        }
        return nil
    }
    
    fileprivate func getFilename(url: URL) -> String {
        return url.relativePath.replacingOccurrences(of: "/", with: "_")
    }
}
