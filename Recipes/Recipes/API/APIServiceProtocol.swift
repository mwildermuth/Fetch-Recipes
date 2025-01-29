//
//  APIServiceProtocol.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//

import Foundation

enum APIErrors: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

protocol APIServiceProtocol {
    associatedtype Model: Decodable
    
    func get(urlString: String) async throws -> Model
}
    
extension APIServiceProtocol {
    func get(urlString: String) async throws -> Model {
        guard let url = URL(string: urlString) else {
            throw APIErrors.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(Model.self, from: data)
            return decodedData
        } catch let error as DecodingError {
            throw APIErrors.decodingError(error)
        } catch {
            throw APIErrors.networkError(error)
        }
    }
}
