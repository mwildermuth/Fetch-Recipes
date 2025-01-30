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
}

#if DEBUG
/**
 * Mocking/Testing services
 */
class MockRecipeServiceEmpty: RecipeService {
    override func get() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
    }
}

class MockRecipeServiceMaliformed: RecipeService {
    override func get() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
    }
}

#endif
