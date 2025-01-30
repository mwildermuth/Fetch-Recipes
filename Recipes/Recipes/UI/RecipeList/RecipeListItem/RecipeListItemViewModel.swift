//
//  RecipeListItemViewModel.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/29/25.
//
import SwiftUI

/**
 * A viw model for the RecipeListItemView.  It is a MainActor. because it updates the UI.
 */
@MainActor
class RecipeListItemViewModel: ObservableObject {
    @Published var recipe: RecipeModel
        
    /**
     * Initialize the view model
     */
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
}
