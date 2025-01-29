//
//  RecipeListItemView.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/29/25.
//
import SwiftUI

struct RecipeListItemView: View {
    
    @StateObject var viewModel: RecipeListItemViewModel
        
    init(recipe: RecipeModel) {
        _viewModel = StateObject(wrappedValue: RecipeListItemViewModel(recipe: recipe))
    }
    
    var body: some View {
        HStack() {
            AsyncImage(url: viewModel.recipe.photoURLSmall) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 100)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(8.0)
                case .failure:
                    Image(systemName: "photo")
                        .frame(width: 100, height: 100)
                @unknown default:
                    Image(systemName: "photo")
                        .frame(width: 100, height: 100)
                }
            }
            
            VStack (alignment: .leading) {
                Spacer()
                Text(viewModel.recipe.name)
                    .font(.headline)
                Text(viewModel.recipe.cuisine)
                    .font(.subheadline)
                if viewModel.recipe.hasExternalURLs() {
                    VStack (alignment: .trailing) {
                        HStack {
                            if let sourceURL = viewModel.recipe.sourceURL {
                                Link(destination: sourceURL) {
                                    Image(systemName: "link")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(.borderless)
                            }
                            if let youtubeURL = viewModel.recipe.youtubeURL {
                                Link(destination: youtubeURL) {
                                    Image(systemName: "play.rectangle")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        .padding(5.0)
                    }
                }
                Spacer()
            }
            .padding(8.0)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    
    let cuisine: String = "Malaysian"
    let name: String = "Apam Balik"
    let udid: String = "0c6ca6e7-e32a-4053-b824-1dbf749910d8"
    let largePhoto: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!
    let smallPhoto: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
    let sourceURL: URL = URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!
    let youtubeURL: URL = URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!
    
    RecipeListItemView(recipe: RecipeModel(cuisine: cuisine, name: name, id: udid , photoURLLarge: largePhoto, photoURLSmall: smallPhoto, sourceURL: sourceURL, youtubeURL: youtubeURL))
}

