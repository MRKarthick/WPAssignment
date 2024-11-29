//
//  Card.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation

final class WPACreditCardDTO: Identifiable {
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

