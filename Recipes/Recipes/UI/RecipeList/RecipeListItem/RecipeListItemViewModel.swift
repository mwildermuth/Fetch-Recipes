//
//  RecipeListItemViewModel.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/29/25.
//
import SwiftUI

@MainActor
class RecipeListItemViewModel: ObservableObject {
    @Published var recipe: RecipeModel
        
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
}
