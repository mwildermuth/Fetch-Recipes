//
//  RecipesMissingView.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import SwiftUI

/**
 * A view that displays a message when no recipes are available.
 */
struct RecipesMissingView: View {
    @ObservedObject var viewModel: RecipesMissingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: viewModel.topImage)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text(viewModel.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(viewModel.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
                Button(action: {
                    // Action is a callback to the view model from the parent view
                    viewModel.action()
                }) {
                    Image(systemName: viewModel.actionImage)
                        .font(.system(size: 40))
                }
        }
    }
}

#if DEBUG
#Preview {
    RecipesMissingView(viewModel: RecipesMissingViewModel(topImage: "tray", title: "No Recipes", description: "You have no available recipes.", action: {() in}, actionImage: "arrow.clockwise.circle"))
}

#Preview {
    RecipesMissingView(viewModel: RecipesMissingViewModel(topImage: "xmark.icloud", title: "Error", description: "Try reloading the recipes again.", action: {() in}, actionImage: "arrow.clockwise.circle"))
}
#endif
