//
//  PlaceholderCell.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import SwiftUI

struct PlaceholderCell: View {
    var body: some View {
        HStack {
            Image(systemName: "bitcoinsign.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text("placeholder-title-label")
                    .bold()
                Text("placeholder-price")
                    .font(.callout)
                Text("placeholder-date-time-label")
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .redacted(reason: .placeholder)
    }
}

#Preview {
    PlaceholderCell()
}
