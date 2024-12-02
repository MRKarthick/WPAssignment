//
//  WPABookmarksView.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 30/11/24.
//

import Foundation
import SwiftUI

struct WPABookmarksView: View {
    @StateObject private var viewModel = WPABookmarksViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                contentView
            }
            .navigationTitle(WPAGenericConstants.TabBar.kBookmarksTabTitle)
            .onAppear {
                viewModel.fetchBookmarkedCards()
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.groupedBookmarks.isEmpty {
            // Show a default view when there are no bookmarks
            WPADefaultContentView(content: WPAGenericConstants.BookmarksPage.kEmptyBookmarksDescription)
        } else if let errorMessage = viewModel.errorMessage {
            // Show an error view if there's an error message
            WPAErrorView(errorMessage: "\(WPAErrorConstants.kGenericErrorTitle): \(errorMessage)")
        } else {
            // Display a list of bookmarks grouped by type
            List {
                ForEach(viewModel.groupedBookmarks, id: \.0) { type, cards in
                    Section(header: Text(type)) {
                        ForEach(cards) { card in
                            // Bookmarks page doesnt need to show the option to toggle.
                            WPACardItemView(card: card, showBookmarks: false)
                        }
                    }
                }
            }
        }
    }
}

// Preview provider for SwiftUI previews
#Preview {
    WPABookmarksView()
}



