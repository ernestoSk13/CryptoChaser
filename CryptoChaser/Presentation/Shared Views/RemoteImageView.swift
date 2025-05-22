//
//  RemoteImageView.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import SwiftUI

struct RemoteImageView: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url, content: { image in
            image
                .resizable()
        }, placeholder: {
            Image(systemName: "bitcoinsign.circle")
                .resizable()
        })
        .scaledToFit()
        .clipShape(Circle())
    }
}

#Preview {
    RemoteImageView(url: Currency.sample.image)
}
