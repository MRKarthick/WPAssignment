//
//  WPABookmarksView.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 30/11/24.
//

import Foundation
import SwiftUI

struct WPABookmarksView: View {
    @StateObject private var viewModel = WPABookmarksViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.groupedBookmarks.isEmpty {
                    Text(WPAGenericConstants.BookmarksPage.kEmptyBookmarksDescription)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("\(WPAErrorConstants.kGenericErrorTitle): \(errorMessage)")
                } else {
                    List {
                        ForEach(viewModel.groupedBookmarks, id: \.0) { type, cards in
                            Section(header: Text(type)) {
                                ForEach(cards) { card in
                                    WPACardItemView(card: card)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(WPAGenericConstants.TabBar.kBookmarksTabTitle)
            .onAppear {
                viewModel.fetchBookmarkedCards()
            }
        }
    }
}

#Preview {
    WPABookmarksView()
}



