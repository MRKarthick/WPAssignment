//
//  WPADashboardView.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 01/12/24.
//

import Foundation
import SwiftUI

struct WPADashboardView: View {
    var body: some View {
        TabView {
            WPACardListView()
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

