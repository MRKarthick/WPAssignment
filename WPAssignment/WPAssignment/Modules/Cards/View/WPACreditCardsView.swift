// WPACreditCardsView.swift
// WPAssignment
// Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.

import SwiftUI

struct WPACreditCardsView: View {
    @StateObject private var viewModel = WPACreditCardViewModel(cardService: WPACreditCardService.shared)

    var body: some View {
        NavigationView {
            VStack {
                contentView
            }
            .navigationTitle(WPAGenericConstants.TabBar.kCreditCardTabTitle)
            .onAppear {
                viewModel.fetchCards()
            }
        }
    }

    // ViewBuilder to conditionally build the content view
    @ViewBuilder
    private var contentView: some View {
        if viewModel.groupedCards.isEmpty {
            // Show a loading view if cards are being fetched
            WPAProgressView(message: WPAGenericConstants.kLoadingPlaceholderDescription)
        } else if viewModel.errorMessage != nil {
            // Show an error view if there's an error message
            WPAErrorView(errorMessage: viewModel.errorMessage ?? "")
        } else {
            // Show a list of cards grouped by type
            List {
                ForEach(viewModel.groupedCards, id: \.0) { type, cards in
                    Section(header: Text(type)) {
                        ForEach(cards) { card in
                            // Display each card with a bookmark toggle action
                            WPACardItemView(card: card) {
                                viewModel.toggleBookmark(card: card)
                            }
                        }
                    }
                }
            }
            .refreshable {
                // Allow the user to refresh the list of cards
                viewModel.fetchCards(isForceFetch: true)
            }
        }
    }
}

// Preview provider for SwiftUI previews
#Preview {
    WPACreditCardsView()
}
