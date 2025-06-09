//
//  CryptoChaserWidget.swift
//  CryptoChaserWidget
//
//  Created by Ernesto Sánchez Kuri on 09/06/25.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CurrencyDetailEntry {
        CurrencyDetailEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> CurrencyDetailEntry {
        CurrencyDetailEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<CurrencyDetailEntry> {
        let service = RemoteCryptoService()
        let repository = DefaultCryptoRepository(service: service, local: CurrencyCoreDataStorage())
        
        guard let currencies = try? await repository.fetchCoins(cached: { _ in
            
        }) else {
            return Timeline(entries: [], policy: .never)
        }
        
        
        let entry = CurrencyDetailEntry(date: Date(), configuration: configuration, currencies: currencies)
        let lastUpdate = Date()
        let nextUpdate = Calendar.current.date(byAdding: DateComponents(minute: 1), to: lastUpdate)!

        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

struct CurrencyDetailEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var currencies: [Currency] = []
}

struct CryptoChaserSmallWidget: View {
    let selectedCurrency: CurrencyDetail
    
    var body: some View {
        VStack {
            Text(selectedCurrency.name)
                .font(.headline)
            RemoteImage(url: selectedCurrency.image)
                .frame(width: 40, height: 40)
                .padding()
            Text("\(selectedCurrency.currentPrice)")
                .font(.subheadline)
                .bold()
            Text("Updated: \(selectedCurrency.lastUpdate)")
                .font(.footnote)
                .foregroundStyle(Color.secondary)
        }
    }
}

struct CryptoChaserMediumWidget: View {
    let selectedCurrency: CurrencyDetail
    
    var body: some View {
        HStack {
            RemoteImage(url: selectedCurrency.image)
                .frame(width: 60, height: 60)
                .padding()
            VStack(alignment: .leading) {
                Text(selectedCurrency.symbol)
                    .font(.headline)
                Text(selectedCurrency.name)
                Text("Updated: \(selectedCurrency.lastUpdate)")
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
            }
            Spacer()
            Text("\(selectedCurrency.currentPrice)")
                .font(.subheadline)
                .bold()
        }
    }
}

struct CryptoChaserWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            if let selectedCurrency = entry.configuration.selectedCurrency {
                if widgetFamily == .systemSmall {
                    CryptoChaserSmallWidget(selectedCurrency: selectedCurrency)
                } else {
                    CryptoChaserMediumWidget(selectedCurrency: selectedCurrency)
                }
            } else {
                Text("No currencies have been stored yet. Open the main app")
            }
        }
    }
}

struct CryptoChaserWidget: Widget {
    let persistenceController = CoreDataManager.shared
    let kind: String = "CryptoChaserWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "com.optionalsankur.cryptochaser.topCurrency",
                               intent: ConfigurationAppIntent.self,
                               provider: Provider(),
                               content: { entry in
            CryptoChaserWidgetEntryView(entry: entry)
                .containerBackground(for: .widget, content: {
                    Color.secondaryBg
                })
                .environment(\.managedObjectContext, persistenceController.context)
        })
        .configurationDisplayName("Crypto Chaser")
        .description("Currency of the day")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge
        ])
    }
}

struct RemoteImage: View {
    var url: URL?
    
    var body: some View {
        if let url, let imageData = try? Data(contentsOf: url),
        let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "bitcoinsign.ring.dashed")
                .resizable()
        }
    }
}
