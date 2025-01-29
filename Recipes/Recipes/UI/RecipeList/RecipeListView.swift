//
//  RecipeListView.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel: RecipeListViewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationStack() {
            VStack {
                switch self.viewModel.state {
                case .loading:
                    ProgressView("Loading...")
                case .empty:
                    self.emptyView
                case .error:
                    self.errorView
                case .loaded:
                    List(viewModel.recipes) { recipe in
                        Text(recipe.name)
                    }
                    .refreshable {
                        await self.viewModel.fetchRecipes()
                    }
                }
            }
            .navigationTitle("Recipes")
        }
        .task {
            await self.viewModel.fetchRecipes()
        }
    }
    
    var errorView: some View {
        RecipesMissingView(viewModel: RecipesMissingViewModel(
            topImage: "xmark.icloud",
            title: "Error",
            description: "Try reloading the recipes again.",
            action: {
                Task {
                    await self.viewModel.fetchWithLoadingState()
                }
            },
            actionImage: "arrow.clockwise.circle"
        ))
    }
    
    var emptyView: some View {
        RecipesMissingView(viewModel: RecipesMissingViewModel(
            topImage: "exclamationmark.triangle",
            title: "No Recipes",
            description: "You have no recipes."
        ))
    }
}

#Preview {
    RecipeListView()
}
