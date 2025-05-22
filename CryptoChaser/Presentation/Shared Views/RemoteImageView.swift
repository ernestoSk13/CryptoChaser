//
//  RemoteImageView.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import SwiftUI

struct RemoteImageView: View {
    let url: URL
    @State private var image: UIImage?
    @Environment(\.imageLoader) private var imageLoader
    var largeSize: Bool = false
    
    var body: some View {
        ZStack {
            if let unwrappedImage = image {
                Image(uiImage: unwrappedImage)
                    .resizable()
            } else {
                ProgressView()
            }
        }.task {
            await loadImage()
        }
    }
    
    func loadImage() async {
        do {
            image = try await imageLoader.fetch(url)
        } catch {
            print(error)
        }
    }
}

#Preview {
    RemoteImageView(url: Currency.sample.image)
}
