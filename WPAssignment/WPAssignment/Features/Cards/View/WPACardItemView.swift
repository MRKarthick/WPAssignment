//
//  WPACardItemView.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 01/12/24.
//

import Foundation
import SwiftUI

struct WPACardItemView: View {
    @State private var card: WPACreditCardDTO
    @State private var isBookmarked: Bool
    var onBookmarkToggle: () -> Void
    
    init(card: WPACreditCardDTO, onBookmarkToggle: @escaping () -> Void) {
        self.card = card
        self.isBookmarked = card.isBookmarked
        self.onBookmarkToggle = onBookmarkToggle
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Card No:  \(card.ccNumber)")
                Text("Exp Date: \(card.ccExpiryDate)")
            }
            Spacer()
            Button(action: {
                isBookmarked.toggle()
                onBookmarkToggle()
            }) {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
