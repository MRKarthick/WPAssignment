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
    // Optional closure to handle bookmark toggle action
    var onBookmarkToggle: (() -> Void)?
    
    init(card: WPACreditCardDTO, onBookmarkToggle: (() -> Void)? = nil) {
        self.card = card
        self.isBookmarked = card.isBookmarked
        self.onBookmarkToggle = onBookmarkToggle
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(WPAGenericConstants.CreditCardItem.kCreditCardNumberTitle):  \(card.ccNumber)")
                Text("\(WPAGenericConstants.CreditCardItem.kCreditCardExpiryTitle): \(card.ccExpiryDate)")
            }
            // If a bookmark toggle handler is provided, show a bookmark button
            if let onBookmarkToggle = onBookmarkToggle {
                Spacer()
                Button(action: {
                    // Toggle bookmark status and call the handler
                    isBookmarked.toggle()
                    onBookmarkToggle()
                }) {
                    // Display bookmark icon based on bookmark status
                    Image(systemName: getBookmarkImageName())
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    // Helper function to determine the bookmark icon name based on bookmark status
    private func getBookmarkImageName() -> String {
        return isBookmarked ? WPAGenericConstants.CreditCardItem.kBookmarkFillImageName : WPAGenericConstants.TabBar.kBookmarkImageName
    }
}
