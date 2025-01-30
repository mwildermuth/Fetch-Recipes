//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Michael Wildermuth on 1/28/25.
//

import Testing
import Foundation
import UIKit
@testable import Recipes

@Suite("Testing the iamge downloading service")
struct ImageServiceTests {
    
    let imageService:ImageService = ImageService()
    let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
    
    @Test("Test downloading an image") func downloadImage() async throws {
        let image = try await imageService.getImage(url: url)
        #expect(image != nil)
    }
}

@Suite("Testing the image to disk caching service", .serialized)
struct ImageCacheManagerTests {
    
    let imageService:ImageService = ImageService()
    let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg")!
    let url2 = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
    let image:UIImage?
    let image2:UIImage?
    
    init() async {
        _ = await ImageCacheManager.shared.clearAll()
        self.image = try? await imageService.getImage(url: url)
        self.image2 = try? await imageService.getImage(url: url2)
    }
    
    @Test("Testing image storing and retrieval") func imageSavedAndRetrived() async throws {
        let imageStored = await ImageCacheManager.shared.storeImage(url: url, image: image!)
        #expect(imageStored == .stored)
        let cachedImage = await ImageCacheManager.shared.retrieveImage(url: url)
        #expect(cachedImage != nil)
        let clearedAll = await ImageCacheManager.shared.clearAll()
        #expect(clearedAll == true)
    }
    
    @Test("Testing image already stored") func imageAlreadyStored() async throws {
        let imageStored = await ImageCacheManager.shared.storeImage(url: url, image: image!)
        try #require(imageStored == .stored)
        let alreadyStored = await ImageCacheManager.shared.storeImage(url: url, image: image!)
        #expect(alreadyStored == .alreadyStored)
        let clearedAll = await ImageCacheManager.shared.clearAll()
        #expect(clearedAll == true)
    }
    
    @Test("Testing image clearing") func imageClearing() async throws {
        let imageStored = await ImageCacheManager.shared.storeImage(url: url2, image: image2!)
        try #require(imageStored == .stored)
        let cleared = await ImageCacheManager.shared.clearImage(url: url2)
        #expect(cleared == true)
        let image = await ImageCacheManager.shared.retrieveImage(url: url2)
        #expect(image == nil)
        let cleardAll = await ImageCacheManager.shared.clearAll()
        #expect(cleardAll == true)
    }
    
    @Test("Testing image already stored") func imageClearingAll() async throws {
        let imageStored = await ImageCacheManager.shared.storeImage(url: url, image: image!)
        try #require(imageStored == .stored)
        let imageStored2 = await ImageCacheManager.shared.storeImage(url: url2, image: image2!)
        try #require(imageStored2 == .stored)
        let cleared = await ImageCacheManager.shared.clearAll()
        #expect(cleared == true)
        let image = await ImageCacheManager.shared.retrieveImage(url: url)
        #expect(image == nil)
        let image2 = await ImageCacheManager.shared.retrieveImage(url: url2)
        #expect(image2 == nil)
        let clearedAll = await ImageCacheManager.shared.clearAll()
        #expect(clearedAll == true)
    }
}

@Suite("Testing the Recipe downloading service")
struct RecipeServiceTests {
    
    @Test("Test downloading recipes") func downloadRecipes() async throws {
        let recipeService:RecipeService = RecipeService()
        do {
            let recipes:RecipeListModel = try await recipeService.get()
            #expect(recipes != nil)
            #expect(recipes.getAllRecipes().count > 0)
        } catch {
            #expect(Bool(false))
        }
    }
    
    @Test("Test malformed recipes throw an error") func malformedRecipes() async throws {
        let recipeService:RecipeService = MockRecipeServiceMaliformed()
        do {
            let _:RecipeListModel = try await recipeService.get()
            #expect(Bool(false))
        } catch {
            #expect(Bool(true))
        }
    }
    
    @Test("Test emppty recipes return an empty list") func emptyRecipes() async throws {
        let recipeService:RecipeService = MockRecipeServiceEmpty()
        do {
            let recipes:RecipeListModel = try await recipeService.get()
            #expect(recipes != nil)
            #expect(recipes.getAllRecipes().isEmpty)
        } catch {
            #expect(Bool(false))
        }
    }
}

@Suite("Testing the Async Image View Model")
struct CachedAsyncImageViewModelTests {
    
    @Test("Test that cache image placeholder phase") func asyncImagePlaceholder() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        let viewModel = await CachedAsyncImageViewModel(url: url)
        switch await viewModel.phase {
            case .empty:
                #expect(Bool(true))
            case .success(_):
                #expect(Bool(false))
            case .failure(_):
                #expect(Bool(false))
        }
    }
    
    @Test("Test that cache image returns successfully") func asyncImageSuccess() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        let viewModel = await CachedAsyncImageViewModel(url: url)
        await viewModel.loadImage()
        switch await viewModel.phase {
            case .empty:
                #expect(Bool(false))
            case .success(_):
                #expect(Bool(true))
            case .failure(_):
                #expect(Bool(false))
        }
    }
    
    @Test("Test that cache image returns a failure") func asyncImageFailure() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/failure.jpg")!
        let viewModel = await CachedAsyncImageViewModel(url: url)
        await viewModel.loadImage()
        switch await viewModel.phase {
            case .empty:
                #expect(Bool(false))
            case .success(_):
                #expect(Bool(false))
            case .failure(_):
                #expect(Bool(true))
        }
    }
}

@Suite("Testing the Recipe List View Model")
struct RecipeListViewModelTests {
    
    @Test("Test that receipes are loaded") func loadRecipes() async throws {
        let viewModel = await RecipeListViewModel()
        await viewModel.fetchRecipes()
        #expect(await viewModel.recipes.count > 0)
    }
    
    @Test("Test that we start in a loading state") func loadingState() async throws {
        let viewModel = await RecipeListViewModel()
        #expect(await viewModel.state == .loading)
    }
    
    @Test("Test that we transition to a loaded state") func loadedState() async throws {
        let viewModel = await RecipeListViewModel()
        await viewModel.fetchRecipes()
        #expect(await viewModel.state == .loaded)
    }
    
    @Test("Test that we transition to a error state") func failedState() async throws {
        let viewModel = await RecipeListViewModel(recipeService: MockRecipeServiceMaliformed())
        await viewModel.fetchRecipes()
        #expect(await viewModel.state == .error)
    }
    
    @Test("Test that we transition to a empty state") func emptyState() async throws {
        let viewModel = await RecipeListViewModel(recipeService: MockRecipeServiceEmpty())
        await viewModel.fetchRecipes()
        #expect(await viewModel.state == .empty)
    }
    
    @Test("Test that filter options are loaded") func loadFilterOptions() async throws {
        let viewModel = await RecipeListViewModel()
        await viewModel.fetchRecipes()
        #expect(await viewModel.filterOptions!.count > 0)
    }
    
    @Test("Test refresh (pull down to refresh) to loaded") func refreshStateToLoaded() async throws {
        let viewModel = await RecipeListViewModel()
        await viewModel.fetchRecipes()
        try #require(await viewModel.state == .loaded)
        await viewModel.fetchWithLoadingState()
        #expect(await viewModel.state == .loaded)
    }
    
    @Test("Test that we have only filtered options") func filterOptions() async throws {
        let testCuisine = "Malaysian"
        let viewModel = await RecipeListViewModel()
        await viewModel.fetchRecipes()
        await viewModel.fitlerRecipes(cuisine: testCuisine)
        let filteredRecipes = await viewModel.recipes
        try #require(filteredRecipes.count > 0)
        for recipe in filteredRecipes {
            if recipe.cuisine != testCuisine {
                #expect(Bool(false))
            }
        }
        #expect(Bool(true))
    }
}

