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
        if viewModel.isLoading {
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
                            // Use a binding to the card's isBookmarked property
                            WPACardItemView(card: card, isBookmarked: Binding(
                                get: { card.isBookmarked },
                                set: { newValue in
                                    viewModel.toggleBookmark(card: card)
                                }
                            ), showBookmarks: true)
                        }
                    }
                }
            }
            .refreshable {
                // Allow the user to refresh the list of cards.
                // This will allow for easy debugging to see if the new data is fetched. UnComment it out if needed.
                viewModel.fetchCards(isForceFetch: true)
            }
        }
    }
}

// Preview provider for SwiftUI previews
#Preview {
    WPACreditCardsView()
}
