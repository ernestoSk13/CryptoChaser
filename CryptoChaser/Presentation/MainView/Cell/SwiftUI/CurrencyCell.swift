//
//  CurrencyCell.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//


import SwiftUI

struct CurrencyCell: View {
    let viewModel: CurrencyCellViewModel
    
    var body: some View {
        HStack {
            RemoteImageView(url: viewModel.imageURL)
                .frame(width: 50, height: 50)
                .padding(.trailing)
                .shadow(radius: 3)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                    .bold()
                Text(viewModel.symbol)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                Text(viewModel.lastUpdated)
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
            Spacer()
            Text(viewModel.price)
                .font(.headline)
                .bold()
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityHidden(true)
    }
}

#Preview {
    CurrencyCell(viewModel: CurrencyCellViewModel(currency: Currency.sample))
}
