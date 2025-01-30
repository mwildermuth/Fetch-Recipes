//
//  ImageService.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/29/25.
//
import Foundation
import UIKit
import SwiftUI

/**
 * A class used to fetch images from the network
 */
class ImageService: APIServiceProtocol {
    typealias Model = Data
    
    /**
     * A method to get an image from a URL
     */
    func getImage(url: URL?) async throws -> UIImage {
        do {
            guard let urlString = url?.absoluteString else {
                throw APIErrors.invalidURL
            }
            let data = try await self.get(urlString: urlString)
                        
            if let uiImage = UIImage(data: data) {
                return uiImage
            } else {
                throw APIErrors.decodingError(NSError(domain: "Image Error", code: 0, userInfo: nil))
            }
        } catch {
            throw APIErrors.networkError(error)
        }
    }
}
