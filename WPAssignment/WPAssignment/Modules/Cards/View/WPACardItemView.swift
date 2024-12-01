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
            if let onBookmarkToggle = onBookmarkToggle {
                Spacer()
                Button(action: {
                    isBookmarked.toggle()
                    onBookmarkToggle()
                }) {
                    Image(systemName: getBookmarkImageName())
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func getBookmarkImageName() -> String {
        return isBookmarked ? WPAGenericConstants.CreditCardItem.kBookmarkFillImageName : WPAGenericConstants.TabBar.kBookmarkImageName
    }
}
