//
//  CurrencyCell.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//


import SwiftUI
import SDWebImage

struct CurrencyCell: View {
    let viewModel: CurrencyCellViewModel
    
    var body: some View {
        HStack {
            RemoteImageView(url: viewModel.imageURL)
                .frame(width: 50, height: 50)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text(viewModel.cellTitle)
                    .bold()
                Text(viewModel.price)
                    .font(.callout)
                Text(viewModel.lastUpdated)
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityHidden(true)
    }
}

#Preview {
    CurrencyCell(viewModel: CurrencyCellViewModel(currency: Currency.sample))
}
