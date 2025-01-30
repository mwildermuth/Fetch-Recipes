//
//  CachedAsyncImageViewModel.swift
//  Recipes
//
//  Created by Michael Wildermuth on 1/29/25.
//
import SwiftUI

public enum CachedAsyncImagePhase : Sendable {
    case empty
    case success(Image)
    case failure(any Error)
}

/**
 * The viewmodel for the CachedAsyncImageView. This class is responsible for loading the image from the network and saving it to disk..  It also manages the state of the image loading process.  It is a MainActor. because it updates the UI.
 */
@MainActor
class CachedAsyncImageViewModel: ObservableObject {

    @Published var phase: CachedAsyncImagePhase = .empty
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func loadImage() async {
        self.phase = .empty
        
        if let image = await ImageCacheManager.shared.retrieveImage(url: url) {
            self.phase = .success(Image(uiImage: image))
            return
        }
        
        do {
            let image:UIImage = try await ImageService().getImage(url: url)
            
            await ImageCacheManager.shared.storeImage(url: url, image: image)
            self.phase = .success(Image(uiImage: image))
        } catch {
            self.phase = .failure(error)
        }
    }
}
