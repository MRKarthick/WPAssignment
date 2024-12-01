//
//  ContentView.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

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

    @ViewBuilder
    private var contentView: some View {
        if viewModel.groupedCards.isEmpty {
            WPAProgressView(message: WPAGenericConstants.kLoadingPlaceholderDescription)
        } else if viewModel.errorMessage != nil {
            WPAErrorView(errorMessage: viewModel.errorMessage ?? "")
        } else {
            List {
                ForEach(viewModel.groupedCards, id: \.0) { type, cards in
                    Section(header: Text(type)) {
                        ForEach(cards) { card in
                            WPACardItemView(card: card) {
                                viewModel.toggleBookmark(card: card)
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
}

#Preview {
    WPACreditCardsView()
}
