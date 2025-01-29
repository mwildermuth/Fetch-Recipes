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
                        RecipeListItemView(recipe: recipe)
                            .listRowSeparator(.hidden)
                    }
                    .refreshable {
                        await self.viewModel.fetchRecipes()
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
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
            topImage: "tray",
            title: "No Recipes",
            description: "You have no recipes.",
            action: {
                Task {
                    await self.viewModel.fetchWithLoadingState()
                }
            },
            actionImage: "arrow.clockwise.circle"
        ))
    }
}

#Preview {
    RecipeListView()
}
