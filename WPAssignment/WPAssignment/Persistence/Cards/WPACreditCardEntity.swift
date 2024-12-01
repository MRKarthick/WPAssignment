//
//  WPACreditCardEntity.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 30/11/24.
//

import Foundation
import SwiftData

@Model
final class WPACreditCardEntity {
    var id: UInt64
    var ccUid: String
    var ccNumber: String
    var ccExpiryDate: String
    var ccType: String
    var isBookmarked: Bool
    
    init(ccId: UInt64, ccUid: String, ccNumber: String, ccExpiryDate: String, ccType: String, isBookmarked: Bool = false) {
        self.id = ccId
        self.ccUid = ccUid
        self.ccNumber = ccNumber
        self.ccExpiryDate = ccExpiryDate
        self.ccType = ccType
        self.isBookmarked = isBookmarked
    }
}

extension WPACreditCardEntity {
    static func getDTOfrom(_ model: WPACreditCardModel) -> WPACreditCardEntity {
        return WPACreditCardEntity(ccId: model.id, ccUid: model.uid, ccNumber: model.creditCardNumber, ccExpiryDate: model.creditCardExpirydate, ccType: model.creditCardType)
    }
}
