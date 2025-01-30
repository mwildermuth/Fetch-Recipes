//
//  RecipesMissingViewModel.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import SwiftUI

/**
 * The viewmodel for the missing recipes view
 */
@MainActor
class RecipesMissingViewModel: ObservableObject {
    @Published var topImage: String
    @Published var title: String
    @Published var description: String
    @Published var action: () -> Void
    @Published var actionImage: String
    
    /**
     * Initialize the view model
     */
    init(topImage: String, title: String, description: String, action: @escaping () -> Void, actionImage: String) {
        self.topImage = topImage
        self.title = title
        self.description = description
        self.action = action
        self.actionImage = actionImage
    }
}
