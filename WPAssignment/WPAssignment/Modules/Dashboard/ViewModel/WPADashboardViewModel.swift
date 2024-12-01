//
//  WPADashboardViewModel.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import Foundation

enum TabType: String, CaseIterable {
    case creditCards
    case bookmarks
}

struct TabItemData {
    let title: String
    let tabImageName: String
    let tabType: TabType
}

class WPADashboardViewModel: ObservableObject {
    @Published var tabItems: [TabItemData] = []
    
    func fetchTabItems() {
        tabItems = [
            TabItemData(
                title: WPAGenericConstants.TabBar.kCreditCardTabTitle,
                tabImageName: WPAGenericConstants.TabBar.kCreditCardImageName,
                tabType: .creditCards),
            TabItemData(
                title: WPAGenericConstants.TabBar.kBookmarksTabTitle,
                tabImageName: WPAGenericConstants.TabBar.kBookmarkImageName,
                tabType: .bookmarks)
        ]
    }
}
