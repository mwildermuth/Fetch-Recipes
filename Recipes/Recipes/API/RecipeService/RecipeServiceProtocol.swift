//
//  RecipeServiceProtocol.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/30/25.
//
import Foundation

protocol RecipeServiceProtocol {
    func get() async throws -> RecipeListModel
}
