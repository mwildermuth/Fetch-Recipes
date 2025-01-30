//
//  ImageCacheManager.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/29/25.
//

import UIKit
import SwiftUI

/**
 *  Define the global actor for the image cache, so it can be used throughout the app.
 */
@globalActor actor ImageCacheActor {

    static let shared = ImageCacheActor()
}

public enum CacheImageStoreState : Sendable {
    case stored
    case alreadyStored
    case failedToStore
}

/**
 * This class is responsible for storing and retrieving images from disk.  A global actor to ensure that only one operation is performed at a time and it can be used from any where in the app.
 */
@ImageCacheActor
class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    fileprivate let cachePath: URL?
    
    /**
     * Initialize the ImageCacheManager, and create an image directory in the cache directory.
     */
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
    
    /**
     * A method to store an image to disk
     */
    func storeImage(url: URL?, image: UIImage) async -> CacheImageStoreState {
        
        guard let url = url else {
            print("URL not found")
            return .failedToStore
        }
        
        guard let cachePath = cachePath else {
            print("Cache path not found")
            return .failedToStore
        }
        
        let imageFileName = self.getFilename(url: url)
        let imagePath = cachePath.appendingPathComponent(imageFileName)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: imagePath.path) == false {
            if fileManager.createFile(atPath: imagePath.path, contents: image.jpegData(compressionQuality: 1.0)) == false {
                print("Error saving image: \(url.path)")
                return .failedToStore
            }
        } else {
            print("Image already exists: \(url.path)")
            return .alreadyStored
        }
        return .stored
    }
    
    /**
     * A method to retrieve an image from disk
     */
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
    
    /**
     * A method to replace / in a path with _ to make a unique filename for the images from the URL path
     */
    fileprivate func getFilename(url: URL) -> String {
        return url.relativePath.replacingOccurrences(of: "/", with: "_")
    }
    
    /**
     * A method to delete a signle image from disk.
     */
    func clearImage(url: URL?) async -> Bool {
        
        guard let url = url else {
            print("URL not found")
            return false
        }
        
        guard let cachePath = cachePath else {
            print("Cache path not found")
            return false
        }
        
        let imageFileName = self.getFilename(url: url)
        let imagePath = cachePath.appendingPathComponent(imageFileName)
        
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: imagePath.path) == true {
                try fileManager.removeItem(atPath: imagePath.path)
            }
        } catch {
            print("Error deleting image: \(url.path)")
            return false
        }
        return true
    }
    
    /**
     * A method to clear all images from disk.
     */
    func clearAll() async -> Bool {
        guard let cachePath = cachePath else {
            print("Cache path not found")
            return false
        }
        
        let fileManager = FileManager.default
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: cachePath, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error deleting all images: \(error.localizedDescription)")
            return false
        }
        return true
    }
}
