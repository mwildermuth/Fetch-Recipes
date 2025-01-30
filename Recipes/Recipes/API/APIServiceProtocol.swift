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

/**
 * Protocol for API Services
 */
protocol APIServiceProtocol {
    associatedtype Model: Decodable
    
    /**
     * Protocol method for all API services to implement or use
     */
    func get(urlString: String) async throws -> Model
}

/**
 * Extension defining default behavior for the protocols
 */
extension APIServiceProtocol {
    
    /**
     * A method to do the HTTP request and decode the response from a given URL
     */
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
    
    /**
     * A mthod to do the HTTP request and return the response as Data
     */
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
