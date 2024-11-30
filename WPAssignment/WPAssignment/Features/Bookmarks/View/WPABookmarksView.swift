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
        Text("Bookmarks View")
    }
}

#Preview {
    WPABookmarksView()
}



