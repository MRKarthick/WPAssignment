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
                        ProgressView("Loading...")
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
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
                .navigationTitle("Credit Cards")
                .onAppear {
                    viewModel.fetchCards()
                }
            }
            .tabItem {
                Label("Credit Cards", systemImage: "creditcard")
            }
            
            WPABookmarksView()
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark")
                }
        }
    }
}

#Preview {
    WPACardListView()
}
