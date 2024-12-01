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
        TabView {
            NavigationView {
                VStack {
                    if viewModel.isLoading {
                        ProgressView(WPAGenericConstants.CreditCardPage.kLoadingPlaceholderDescription)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("\(WPAErrorConstants.kGenericErrorTitle): \(errorMessage)")
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
                .navigationTitle(WPAGenericConstants.TabBar.kCreditCardTabTitle)
                .onAppear {
                    viewModel.fetchCards()
                }
            }
            .tabItem {
                Label(WPAGenericConstants.TabBar.kCreditCardTabTitle, systemImage: WPAGenericConstants.TabBar.kCreditCardImageName)
            }
            
            WPABookmarksView()
                .tabItem {
                    Label(WPAGenericConstants.TabBar.kBookmarksTabTitle, systemImage: WPAGenericConstants.TabBar.kBookmarkImageName)
                }
        }
    }
}

#Preview {
    WPACardListView()
}
