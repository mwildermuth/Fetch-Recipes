//
//  CachedAsyncImageView.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/29/25.
//
import SwiftUI

/**
 * A view that asynchronously loads an image from a URL and saves it to disk, for repeated use.
 */
struct CachedAsyncImageView<Content>: View where Content: View {
    @StateObject var viewModel: CachedAsyncImageViewModel
    
    @ViewBuilder private var content: (CachedAsyncImagePhase) -> Content
    
    /**
     * Initializes the view with a URL and a content view.
     */
    init(url: URL?, @ViewBuilder content: @escaping (CachedAsyncImagePhase) -> Content) {
        self.content = content
        self._viewModel = StateObject(wrappedValue: CachedAsyncImageViewModel(url: url))
    }
    
    var body: some View {
        content(viewModel.phase)
            .task {
                await viewModel.loadImage()
            }
    }
}
