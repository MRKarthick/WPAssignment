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
                                    WPACardItemView(card: card)
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
    
    func getCardImage(_ card: WPACreditCardDTO) -> String {
        if card.isBookmarked {
            print("Bookmarked")
        } else {
            print("Not Bookmarked")
        }
        return card.isBookmarked ? "bookmark.fill" : "bookmark"
    }
}

#Preview {
    WPACardListView()
}
