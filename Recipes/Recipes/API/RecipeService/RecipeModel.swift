//
//  RecipeModel.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import Foundation

struct RecipesModel: Decodable {
    let recipes: [RecipeModel]
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
        case id = "uuid"
        case name
        case cuisine
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
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
    
