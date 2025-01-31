//
//  RecipeService.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import Foundation

/**
 * Service for fetching recipes from the API
 */
class RecipeService: APIServiceProtocol, RecipeServiceProtocol {
    typealias Model = RecipeListModel
    
    /**
     * A method to fetch the recipe list from the API
     */
    public func get() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
    }
    
    /**
     * Helper method to do the HTTP request and decode the response from a given URL
     */
    internal func getRecipeList(urlString: String) async throws -> RecipeListModel {
        do {
            let recipeList = try await self.get(urlString: urlString)
            return recipeList
        } catch {
            throw error
        }
    }
    
    func makeRequest(url: URL) async throws -> (Data, URLResponse) {
        return try await self.defaultMakeRequest(url: url)
    }
}

#if DEBUG
/**
 * Mocking of a valid JSON response for Unit Testing
 */
class MockRecipeService: RecipeService {
    
    override func makeRequest(url: URL) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let jsonString = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
                {
                    "cuisine": "British",
                    "name": "Apple & Blackberry Crumble",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                    "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                },
                {
                    "cuisine": "British",
                    "name": "Apple Frangipan Tart",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7276e9f9-02a2-47a0-8d70-d91bdb149e9e/small.jpg",
                    "uuid": "74f6d4eb-da50-4901-94d1-deae2d8af1d1",
                    "youtube_url": "https://www.youtube.com/watch?v=rp8Slv4INLk"
                },
                {
                    "cuisine": "British",
                    "name": "Bakewell Tart",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/dd936646-8100-4a1c-b5ce-5f97adf30a42/small.jpg",
                    "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
                    "youtube_url": "https://www.youtube.com/watch?v=1ahpSTf_Pvk"
                },
                {
                    "cuisine": "American",
                    "name": "Banana Pancakes",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/banana-pancakes",
                    "uuid": "f8b20884-1e54-4e72-a417-dabbc8d91f12",
                    "youtube_url": "https://www.youtube.com/watch?v=kSKtb2Sv-_U"
                },
                {
                    "cuisine": "British",
                    "name": "Battenberg Cake",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec1b84b1-2729-4547-99db-5e0b625c0356/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ec1b84b1-2729-4547-99db-5e0b625c0356/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/1120657/battenberg-cake",
                    "uuid": "891a474e-91cd-4996-865e-02ac5facafe3",
                    "youtube_url": "https://www.youtube.com/watch?v=aB41Q7kDZQ0"
                }
            ]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        return (jsonData, response)
    }
}

/**
 * Mocking an empty JSON Response for Unit Testing
 */
class MockRecipeServiceEmpty: RecipeService {
    
    override func get() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
    }
    
    override func makeRequest(url: URL) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let jsonString = """
        {
            "recipes": []
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        return (jsonData, response)
    }
}

/**
 * Mocking an maliformed JSON Response for Unit Testing
 */
class MockRecipeServiceMaliformed: RecipeService {
    
    override func get() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
    }
    
    override func makeRequest(url: URL) async throws -> (Data, URLResponse) {
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let jsonString = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
                {
                    "cuisine": "British",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                    "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                }
            ]
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        return (jsonData, response)
    }
}

/**
 * Used for local testing of live reprsentation of an empty recipe list
 */
class MockRecipeServiceAPIEmpty: RecipeService {
    override func get() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
    }
}

/**
 * Used for local testing of live reprsentation of an maliformed recipe list
 */
class MockRecipeServiceAPIMaliformed: RecipeService {
    override func get() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
    }
}

#endif
