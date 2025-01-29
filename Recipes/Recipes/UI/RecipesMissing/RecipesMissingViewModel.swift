//
//  RecipesMissingViewModel.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import SwiftUI

@MainActor
class RecipesMissingViewModel: ObservableObject {
    @Published var topImage: String
    @Published var title: String
    @Published var description: String
    @Published var action: (() -> Void)?
    @Published var actionImage: String?
    
    init(topImage: String, title: String, description: String, action: (() -> Void)? = nil, actionImage: String? = nil) {
        self.topImage = topImage
        self.title = title
        self.description = description
        self.action = action
        self.actionImage = actionImage
    }
}
