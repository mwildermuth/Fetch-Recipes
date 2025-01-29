//
//  RecipesMissingView.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/28/25.
//
import SwiftUI

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
            
            if let action = viewModel.action, let actionImage = viewModel.actionImage {
                Button(action: {
                    action()
                }) {
                    Image(systemName: actionImage)
                        .font(.system(size: 40))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

