//
//  WPADashboardView.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 01/12/24.
//

import Foundation
import SwiftUI

struct WPADashboardView: View {
    @StateObject private var viewModel = WPADashboardViewModel()
    
    var body: some View {
        TabView {
            contentView
                .onAppear() {
                    viewModel.fetchTabItems()
                }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.tabItems.isEmpty {
            WPAProgressView(message: WPAGenericConstants.kLoadingPlaceholderDescription)
        } else {
            ForEach(viewModel.tabItems, id: \.title) { tabItem in
                tabView(for: tabItem)
                    .tabItem {
                        Label(tabItem.title, systemImage: tabItem.tabImageName)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func tabView(for tabItem: TabItemData) -> some View {
        switch tabItem.tabType {
        case .creditCards:
            WPACreditCardsView()
        case .bookmarks:
            WPABookmarksView()
        }
    }
}

#Preview {
    WPACreditCardsView()
}

