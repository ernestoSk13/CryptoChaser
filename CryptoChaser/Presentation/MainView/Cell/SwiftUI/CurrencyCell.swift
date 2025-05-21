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
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .bold()
                Text(viewModel.price)
                    .font(.callout)
                Text(viewModel.lastUpdated)
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CurrencyCell(viewModel: CurrencyCellViewModel(currency: Currency.sample))
}
