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

/**
 * The viewmodel for the RecipeListView.  It is responsible for fetching the recipes and managing the state of the view.  It is a MainActor because it updates the UI.
 */
@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var state: RecipeListViewStates = .loading
    @Published var recipes: [RecipeModel] = []
    @Published var filterOptions: [String]? = nil
    
    // Hold all the recipes to filter on
    fileprivate var storedRecipes: RecipeListModel?
    // Used to represent the "All" cusisine filter option
    fileprivate var filterAllKey: String = "All"
    
    /**
     * A method that fetches the recipes from the service. It is an async method because it calls an async method from the RecipeService.
     */
    func fetchRecipes() async {
        do {
            self.filterOptions = nil
            let recipes:RecipeListModel = try await RecipeService().get()
            if recipes.getAllRecipes().isEmpty {
                self.state = .empty
            } else {
                self.storedRecipes = recipes
                self.recipes = recipes.getAllRecipes()
                self.filterOptions = recipes.getAllCuisines()
                // Force the "All" cusisine filter option to the top of the list
                self.filterOptions?.insert(filterAllKey, at: 0)
                self.state = .loaded
            }
        } catch {
            self.state = .error
        }
    }
    
    /**
     * A method that fetches the recipes from the service with a loading state. It is an async method because it calls an async method from the RecipeService.
     */
    func fetchWithLoadingState() async {
        self.state = .loading
        await self.fetchRecipes()
    }
    
    /**
     * A method that filters the recipes based on the cuisine.
     */
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
