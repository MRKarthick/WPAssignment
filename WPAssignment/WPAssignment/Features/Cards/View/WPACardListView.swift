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
                    List {
                        ForEach(viewModel.groupedCards, id: \.0) { type, cards in
                            Section(header: Text(type)) {
                                ForEach(cards) { card in
                                    NavigationLink(destination: WPACardDetailView(creditCard: card)) {
                                        VStack(alignment: .leading) {
                                            Text("Card No:  \(card.ccNumber)")
                                            Text("Exp Date: \(card.ccExpiryDate)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .refreshable {
                        viewModel.fetchCards(isForceFetch: true)
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
