//
//  WPACreditCardEntity.swift
//  WPAssignment
//
//  Created by EdgeCaseDesigns on 30/11/24.
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
    
    init(ccId: UInt64, ccUid: String, ccNumber: String, ccExpiryDate: String, ccType: String) {
        self.id = ccId
        self.ccUid = ccUid
        self.ccNumber = ccNumber
        self.ccExpiryDate = ccExpiryDate
        self.ccType = ccType
    }
    
    class func getDTOfrom(_ model: WPACreditCardModel) -> WPACreditCardDTO {
        return WPACreditCardDTO(ccId: model.id, ccUid: model.uid, ccNumber: model.creditCardNumber, ccExpiryDate: model.creditCardExpirydate, ccType: model.creditCardType)
    }
}

