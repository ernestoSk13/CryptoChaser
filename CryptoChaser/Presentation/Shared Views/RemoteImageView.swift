//
//  RemoteImageView.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct RemoteImageView: View {
    let url: URL
    
    var body: some View {
        WebImage(url: url) { image in
            image
                .resizable()
                
        } placeholder: {
            Image(systemName: "bitcoinsign.circle")
                .resizable()
        }
        .indicator(.activity)
        .transition(.fade(duration: 0.3))
        .scaledToFit()
        .frame(width: 50, height: 50)
    }
}

#Preview {
    RemoteImageView(url: Currency.sample.image)
}
