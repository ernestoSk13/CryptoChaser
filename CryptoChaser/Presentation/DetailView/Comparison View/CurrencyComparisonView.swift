//
//  CurrencyComparisonView.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 09/06/25.
//

import SwiftUI
import Charts

struct CurrencyComparisonView: View {
    let viewModel: CurrencyComparisonViewModel
    @Binding var selectedCurrency: String?
    @Binding var scrollPosition: String
    
    var body: some View {
        VStack {
            Chart {
                ForEach(viewModel.currencies, id: \.id) { currency in
                    BarMark(x: .value("Currency", currency.name), y: .value(viewModel.title, viewModel.valueForProperty(currency: currency)))
                        .foregroundStyle(currency.name == viewModel.currentCurrency.name ? Color.green : Color.blue)
                }
                
                if let selectedCurrency {
                    RectangleMark(x: .value("Currency", selectedCurrency))
                        .foregroundStyle(Color.gray.opacity(0.2))
                        .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit(to: .chart), y: .fit)) {
                            if let currency = viewModel.lookForCoinWith(name: selectedCurrency) {
                                AnnotationView(title: selectedCurrency,
                                               value: viewModel.annotationValue(for: currency))
                            }
                        }
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartXSelection(value: $selectedCurrency)
            .chartScrollPosition(x: $scrollPosition)
            .chartScrollTargetBehavior(.paging)
        }
        .padding()
        .onAppear {
            selectedCurrency = viewModel.currentCurrency.name
        }
    }
}

struct AnnotationView: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack {
            Text(title)
                .bold()
            Text(value)
        }.padding()
            .background(Color(UIColor.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}
