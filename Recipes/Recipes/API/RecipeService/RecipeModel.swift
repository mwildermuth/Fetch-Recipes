//
//  RecipeModel.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import Foundation

/**
 * A struct that represents the return value of the API call to get all recipes.
 */
struct RecipeListModel: Decodable {
    private let recipes: [RecipeModel]
    
    /**
     * A method to get all recipes.
     */
    func getAllRecipes() -> [RecipeModel] {
        return self.recipes
    }
    
    /**
     * A method to get a unique list of all cuisines from the recipes.
     */
    func getAllCuisines() -> [String] {
        let uniqueCuisines = Set(self.recipes.map { $0.cuisine })
        return Array(uniqueCuisines)
    }
    
    /**
     * A method to get all recipes from a specific cuisine.
     */
    func getAllRecipesFromCuisine(cuisine: String) -> [RecipeModel] {
        return self.recipes.filter { $0.cuisine == cuisine }
    }
}

/**
 * A struct representing a single recipe.
 */
struct RecipeModel: Decodable, Identifiable {
    let cuisine: String
    let name: String
    let id: String
    let photoURLLarge: URL?
    let photoURLSmall: URL?
    let sourceURL: URL?
    let youtubeURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case id = "uuid"
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    /**
     * Helper method to determine if the recipe has any external URLs
     */
    func hasExternalURLs() -> Bool {
        return sourceURL != nil || youtubeURL != nil
    }
}

/**
 * Extension to conform to the Hashable protocol to allow the looping through the recipes in the view.
 */
extension RecipeModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.id == rhs.id
    }
}
    
