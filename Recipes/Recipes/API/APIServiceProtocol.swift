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
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = (response as? HTTPURLResponse)?.statusCode, httpResponse != 200 {
                throw APIErrors.networkError(NSError(domain: "HTTP Error", code: httpResponse, userInfo: nil))
            }
            
            let decodedData = try JSONDecoder().decode(Model.self, from: data)
            return decodedData
        } catch let error as DecodingError {
            throw APIErrors.decodingError(error)
        } catch {
            throw APIErrors.networkError(error)
        }
    }
    
    func get(urlString: String) async throws -> Model where Model == Data {
        
        guard let url = URL(string: urlString) else {
            throw APIErrors.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = (response as? HTTPURLResponse)?.statusCode, httpResponse != 200 {
                throw APIErrors.networkError(NSError(domain: "HTTP Error", code: httpResponse, userInfo: nil))
            }
            
            return data
        } catch {
            throw APIErrors.networkError(error)
        }
    }
}
