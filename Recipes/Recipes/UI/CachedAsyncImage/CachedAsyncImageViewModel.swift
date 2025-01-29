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

@MainActor
class CachedAsyncImageViewModel: ObservableObject {

    @Published var phase: CachedAsyncImagePhase = .empty
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func loadImage() async {
        self.phase = .empty
        do {
            let image:Image = try await ImageService().getImage(url: url)
            self.phase = .success(image)
        } catch {
            self.phase = .failure(error)
        }
    }
}
