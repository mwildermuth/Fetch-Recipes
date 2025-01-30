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
    @Published var filterOptions: [String]? = nil
    fileprivate var storedRecipes: RecipeListModel?
    fileprivate var filterAllKey: String = "All"
    
    func fetchRecipes() async {
        do {
            let recipes:RecipeListModel = try await RecipeService().get()
            if recipes.getAllRecipes().isEmpty {
                self.state = .empty
            } else {
                self.storedRecipes = recipes
                self.recipes = recipes.getAllRecipes()
                self.filterOptions = recipes.getAllCuisines()
                self.filterOptions?.insert(filterAllKey, at: 0)
                self.state = .loaded
            }
        } catch {
            self.state = .error
        }
    }
    
    func fetchWithLoadingState() async {
        self.filterOptions = nil
        self.state = .loading
        await self.fetchRecipes()
    }
    
    func fitlerRecipes(cuisine: String) {
        if let storedRecipes = self.storedRecipes {
            if cuisine == filterAllKey {
                self.recipes = storedRecipes.getAllRecipes()
            } else {
                self.recipes = storedRecipes.getAllRecipesFromCuisine(cuisine: cuisine)
            }
        }
    }
}
