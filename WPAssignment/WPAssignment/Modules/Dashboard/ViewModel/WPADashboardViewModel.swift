//
//  WPADashboardViewModel.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import Foundation

enum WPATabType: String, CaseIterable {
    case creditCards
    case bookmarks
}

struct WPATabItemData {
    let title: String
    let tabImageName: String
    let tabType: WPATabType
}

class WPADashboardViewModel: ObservableObject {
    @Published var tabItems: [WPATabItemData] = []
    
    func fetchTabItems() {
        tabItems = [
            WPATabItemData(
                title: WPAGenericConstants.TabBar.kCreditCardTabTitle,
                tabImageName: WPAGenericConstants.TabBar.kCreditCardImageName,
                tabType: .creditCards),
            WPATabItemData(
                title: WPAGenericConstants.TabBar.kBookmarksTabTitle,
                tabImageName: WPAGenericConstants.TabBar.kBookmarkImageName,
                tabType: .bookmarks)
        ]
    }
}
