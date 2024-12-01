//
//  Card.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation

final class WPACreditCardDTO: Identifiable, Equatable {
    static func == (lhs: WPACreditCardDTO, rhs: WPACreditCardDTO) -> Bool {
        lhs.id == rhs.id && lhs.ccUid == rhs.ccUid && lhs.ccNumber == rhs.ccNumber && lhs.ccExpiryDate == rhs.ccExpiryDate && lhs.ccType == rhs.ccType
    }
    
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
    
    class func getDTOfrom(_ model: WPACreditCardModel) -> WPACreditCardDTO {
        return WPACreditCardDTO(ccId: model.id, ccUid: model.uid, ccNumber: model.creditCardNumber, ccExpiryDate: model.creditCardExpirydate, ccType: model.creditCardType)
    }
    
    class func getDTOfrom(_ entity: WPACreditCardEntity) -> WPACreditCardDTO {
        let ccDto = WPACreditCardDTO(ccId: entity.id, ccUid: entity.ccUid, ccNumber: entity.ccNumber, ccExpiryDate: entity.ccExpiryDate, ccType: entity.ccType)
        ccDto.isBookmarked = entity.isBookmarked
        return ccDto
    }
    
    static func groupAndSortCreditCards(_ cards: [WPACreditCardDTO]) -> [(key: String, value: [WPACreditCardDTO])] {
        return Dictionary(grouping: cards, by: { $0.ccType })
            .sorted(by: { $0.key < $1.key })
    }
}

