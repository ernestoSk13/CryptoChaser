//
//  MainListErrorView.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import SwiftUI

struct MainListErrorView: View {
    let reloadAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("There was an error fetching from the server. Please try again")
                .padding()
            LottieView(filename: "ErrorAnimation")
                .frame(width: 300, height: 200)
            Spacer()
            Button {
                reloadAction()
            } label: {
                Label {
                    Text("Reload Data")
                } icon: {
                    Image(systemName: "arrow.clockwise")
                }

            }
            Spacer()
        }
    }
}

#Preview {
    MainListErrorView {
        
    }
}
