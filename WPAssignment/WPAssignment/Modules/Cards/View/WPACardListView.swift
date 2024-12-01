//
//  ContentView.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import SwiftUI

struct WPACardListView: View {
    @StateObject private var viewModel = WPACreditCardViewModel()

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
        if viewModel.isLoading {
            ProgressView(WPAGenericConstants.CreditCardPage.kLoadingPlaceholderDescription)
        } else if viewModel.errorMessage != nil {
            ErrorView(errorMessage: viewModel.errorMessage ?? "")
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
                viewModel.fetchCards()
            }
        }
    }
}

#Preview {
    WPACardListView()
}
