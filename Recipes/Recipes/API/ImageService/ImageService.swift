//
//  ImageService.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/29/25.
//
import Foundation
import UIKit
import SwiftUI

class ImageService {
    func getImage(url: URL?) async throws -> UIImage {
        do {
            guard let url = url else {
                throw APIErrors.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = (response as? HTTPURLResponse)?.statusCode, httpResponse != 200 {
                throw APIErrors.networkError(NSError(domain: "HTTP Error", code: httpResponse, userInfo: nil))
            }
            
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
