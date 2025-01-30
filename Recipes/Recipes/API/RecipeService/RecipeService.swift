//
//  RecipeService.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import Foundation

class RecipeService: APIServiceProtocol {
    typealias Model = RecipeListModel
    
    public func get() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
    }
    
    private func getRecipeList(urlString: String) async throws -> RecipeListModel {
        do {
            let recipeList = try await self.get(urlString: urlString)
            return recipeList
        } catch {
            throw error
        }
    }
}

#if DEBUG
// Used for mocking/testing
extension RecipeService {
    public func getEmpty() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
    }
    
    public func getMalformed() async throws -> RecipeListModel {
        try await self.getRecipeList(urlString: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
    }
}

#endif
