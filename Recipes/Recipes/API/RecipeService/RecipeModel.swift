//
//  RecipeModel.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import Foundation

struct RecipeListModel: Decodable {
    private let recipes: [RecipeModel]
    
    func getAllRecipes() -> [RecipeModel] {
        return self.recipes
    }
    
    func getAllCuisines() -> [String] {
        let uniqueCuisines = Set(self.recipes.map { $0.cuisine })
        return Array(uniqueCuisines)
    }
    
    func getAllRecipesFromCuisine(cuisine: String) -> [RecipeModel] {
        return self.recipes.filter { $0.cuisine == cuisine }
    }
}

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
    
    func hasExternalURLs() -> Bool {
        return sourceURL != nil || youtubeURL != nil
    }
}

extension RecipeModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.id == rhs.id
    }
}
    
