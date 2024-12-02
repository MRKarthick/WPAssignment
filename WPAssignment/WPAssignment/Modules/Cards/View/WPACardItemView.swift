//
//  WPACardItemView.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import Foundation
import SwiftUI

struct WPACardItemView: View {
    @Binding var isBookmarked: Bool
    var card: WPACreditCardDTO
    var showBookmarks: Bool?
    
    init(card: WPACreditCardDTO, isBookmarked: Binding<Bool> = .constant(false), showBookmarks: Bool? = nil) {
        self.card = card
        self._isBookmarked = isBookmarked
        self.showBookmarks = showBookmarks
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(WPAGenericConstants.CreditCardItem.kCreditCardNumberTitle):  \(card.ccNumber)")
                Text("\(WPAGenericConstants.CreditCardItem.kCreditCardExpiryTitle): \(card.ccExpiryDate)")
            }
            if showBookmarks ?? false {
                Spacer()
                Button(action: {
                    // Toggle bookmark status and call the handler
                    isBookmarked.toggle()
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
