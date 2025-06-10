//
//  CurrencyDetailView.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 07/06/25.
//

import SwiftUI

struct CurrencyDetailView: View {
    @Namespace private var animation
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var viewModel: CurrencyDetailViewModel
    private let viewIdentifier = "detail_view"
    @State var price: String = "0"
    @State var currentTab = 0
    var isIpad = UIDevice.current.userInterfaceIdiom == .pad
    @State var scrollPosition = ""
    @State var selectedCurrency: String? = ""
    
    var verticalHeader: some View {
        VStack {
            RemoteImageView(url: viewModel.imageUrl)
                .frame(width: 120, height: 120)
                .padding(12)
                .accessibilityIdentifier(Constants.Accessibility.DetailView.Logo.identifier)
                .accessibilityLabel(Constants.Accessibility.DetailView.Logo.label)
            priceLabel
        }.matchedGeometryEffect(id: "HeaderView", in: animation)
    }
    
    var horizontalHeader: some View {
        HStack {
            RemoteImageView(url: viewModel.imageUrl)
                .frame(width: 60, height: 60)
                .padding(12)
                .accessibilityIdentifier(Constants.Accessibility.DetailView.Logo.identifier)
                .accessibilityLabel(Constants.Accessibility.DetailView.Logo.label)
            priceLabel
        }.matchedGeometryEffect(id: "HeaderView", in: animation)
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
                if !isIpad {
                    verticalHeader
                } else {
                    horizontalHeader
                }
                
                Picker("", selection: $currentTab) {
                    Text("Info").tag(0)
                    Text("Comparison").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if currentTab == 0 {
                    VStack {
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
                } else {
                    VStack {
                        Menu {
                            ForEach(0 ..< viewModel.properties.count, id: \.self) { idx in
                                let property = viewModel.properties[idx]
                                Button {
                                    viewModel.selectedProperty = idx
                                } label: {
                                    Label {
                                        Text(property.title)
                                    } icon: {
                                        Image(systemName: property.icon)
                                            .controlSize(.large)
                                    }

                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.properties[viewModel.selectedProperty].title)
                                Image(systemName: "chevron.down")
                                    .controlSize(.large)
                            }
                        }.padding()
                            .buttonStyle(BorderedButtonStyle())
                        
                        let selectedProperty = viewModel.properties[viewModel.selectedProperty]
                        CurrencyComparisonView(viewModel: CurrencyComparisonViewModel(currentCurrency: viewModel.currency,
                                                                                      title: selectedProperty.title,
                                                                                      coins: viewModel.coins,
                                                                                      selectedProperty: selectedProperty.associatedSorting),
                                               selectedCurrency: $selectedCurrency,
                                               scrollPosition: $scrollPosition)
                    }.background(Color.secondaryBg)
                }
            }
        .navigationTitle(Text("\(viewModel.name) (\(viewModel.symbol))"))
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.main)
        .onChange(of: viewModel.selectedProperty) { oldValue, newValue in
            let property = viewModel.properties[newValue]
            viewModel.fillCoinsArray(sortedBy: property.associatedSorting)
        }.onAppear {
            scrollPosition = viewModel.name
            selectedCurrency = viewModel.name
        }
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
        CurrencyDetailView(viewModel: CurrencyDetailViewModel(currency: Currency.sample, repository: MockCryptoRepository()))
    }
}
