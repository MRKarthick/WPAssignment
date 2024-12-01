//
//  WPACreditCardModel.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation

final class WPACreditCardModel: Decodable {
    var id: UInt64
    var uid: String
    var creditCardNumber: String
    var creditCardExpirydate: String
    var creditCardType: String
    
    init(id: UInt64, uid: String, creditCardNumber: String, creditCardExpirydate: String, creditCardType: String) {
        self.id = id
        self.uid = uid
        self.creditCardNumber = creditCardNumber
        self.creditCardExpirydate = creditCardExpirydate
        self.creditCardType = creditCardType
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UInt64.self, forKey: .id)
        uid = try container.decode(String.self, forKey: .uid)
        creditCardNumber = try container.decode(String.self, forKey: .credit_card_number)
        creditCardExpirydate = try container.decode(String.self, forKey: .credit_card_expiry_date)
        creditCardType = try container.decode(String.self, forKey: .credit_card_type)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case uid
        case credit_card_number
        case credit_card_expiry_date
        case credit_card_type
    }
}

