//
//  WPAGenericConstants.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 30/11/24.
//

import Foundation

struct WPAGenericConstants {
    static let kLoadingPlaceholderDescription: String = "Loading..."

    struct TabBar {
        static let kCreditCardTabTitle = "Credit Cards"
        static let kCreditCardImageName: String = "creditcard"
        static let kBookmarksTabTitle = "Bookmarks"
        static let kBookmarkImageName: String = "bookmark"
    }
    
    struct CreditCardItem {
        static let kCreditCardNumberTitle: String = "Card No"
        static let kCreditCardExpiryTitle: String = "Exp Date"
        static let kBookmarkFillImageName: String = "bookmark.fill"
    }
    
    struct CreditCardPage {
        static let kEmptyCreditCardDescription: String = "There are no Credit Cards"
    }
    
    struct BookmarksPage {
        static let kEmptyBookmarksDescription: String = "There are no Bookmarks"
    }
}
