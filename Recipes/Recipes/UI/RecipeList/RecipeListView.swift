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
            .navigationBarItems(trailing: navBarItem)
        }
        .task {
            await self.viewModel.fetchRecipes()
        }
    }
    
    @ViewBuilder
    var navBarItem: some View {
        if let filterOptions = self.viewModel.filterOptions, filterOptions.isEmpty == false {
            Menu {
                ForEach(filterOptions, id: \.self) { option in
                    Button(action: {
                        self.viewModel.fitlerRecipes(cuisine: option)
                    }) {
                        Text(option)
                    }
                }
            } label: {
                Label("Filter", systemImage: "slider.horizontal.3")
            }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
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
    
    @ViewBuilder
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
