//
//  ContentView.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import SwiftUI
import SwiftData

struct WPACardListView: View {
    @StateObject private var viewModel = WPACreditCardViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                } else {
                    List(viewModel.cards) { card in
                        NavigationLink(destination: WPACardDetailView(creditCard: card)) {
                            Text("\(card.credit_card_type): \(card.credit_card_number)")
                        }
                    }
                }
            }
            .navigationTitle("Credit Cards")
            .onAppear {
                viewModel.fetchCards()
            }
        }
    }
}

#Preview {
    WPACardListView()
}
