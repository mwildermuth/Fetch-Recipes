//
//  RecipeListViewModel.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import SwiftUI

enum RecipeListViewStates {
    case loading
    case loaded
    case empty
    case error
}

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var state: RecipeListViewStates = .loading
    @Published var recipes: [RecipeModel] = []
    
    func fetchRecipes() async {
        do {
            let recipes:[RecipeModel] = try await RecipeService().get()
            if recipes.isEmpty {
                self.state = .empty
            } else {
                self.recipes = recipes
                self.state = .loaded
            }
        } catch {
            self.state = .error
        }
    }
    
    func fetchWithLoadingState() async {
        self.state = .loading
        await self.fetchRecipes()
    }
}
