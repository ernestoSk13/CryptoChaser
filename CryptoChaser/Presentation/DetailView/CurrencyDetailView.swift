//
//  CurrencyDetailView.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 07/06/25.
//

import SwiftUI

struct CurrencyDetailView: View {
    let viewModel: CurrencyDetailViewModel
    private let viewIdentifier = "detail_view"
    @State var price: String = "0"
    
    var header: some View {
        HStack {
            Spacer()
            Text("\(viewModel.name) (\(viewModel.symbol))")
                .font(.headline)
            Spacer()
        }
    }
    
    var priceLabel: some View {
        Text("\(price)")
            .font(.largeTitle)
            .contentTransition(.numericText(value: viewModel.currentPriceValue))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        price = viewModel.currentPrice
                    }
                }
            }.padding()
            .accessibilityLabel(Constants.Accessibility.DetailView.Price.label)
            .accessibilityValue(viewModel.currentPrice)
            .accessibilityIdentifier(Constants.Accessibility.DetailView.Price.identifier)
    }
    
    var body: some View {
            VStack(alignment: .center) {
                RemoteImageView(url: viewModel.imageUrl)
                    .frame(width: 120, height: 120)
                    .padding(12)
                    .accessibilityIdentifier(Constants.Accessibility.DetailView.Logo.identifier)
                    .accessibilityLabel(Constants.Accessibility.DetailView.Logo.label)
                priceLabel
                    
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.properties) { property in
                            CurrencyPropertyView(title: property.title,
                                                 value: property.value)
                            .accessibilityIdentifier(Constants.Accessibility.DetailView.Property.identifier.replacingOccurrences(of: "%@", with: property.id))
                            Divider()
                        }
                        Spacer()
                    }
                }.padding(12)
                .background(Color.secondaryBg)
            }
        .navigationTitle(Text("\(viewModel.name) (\(viewModel.symbol))"))
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.main)
    }
    
    static func makeCurrencyDetailView(viewModel: CurrencyDetailViewModel) -> UIViewController {
        let hostingController = UIHostingController(rootView: CurrencyDetailView(viewModel: viewModel))
        
        return hostingController
    }
}

struct CurrencyPropertyView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
            Spacer()
            Text(value)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
        }.padding()
            .accessibilityElement(children: .combine)
            .accessibilityLabel(title)
            .accessibilityValue(value)
    }
}

#Preview {
    NavigationStack {
        CurrencyDetailView(viewModel: CurrencyDetailViewModel(currency: Currency.sample))
    }
}
