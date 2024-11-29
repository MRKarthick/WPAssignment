//
//  Card.swift
//  WPAssignment
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 29/11/24.
//

import Foundation
import SwiftData

@Model
final class CreditCard: Decodable {
    var id: UInt64
    var uid: String
    var credit_card_number: String
    var credit_card_expiry_date: String
    var credit_card_type: String
    
    init(id: UInt64, uid: String, credit_card_number: String, credit_card_expiry_date: String, credit_card_type: String) {
        self.id = id
        self.uid = uid
        self.credit_card_number = credit_card_number
        self.credit_card_expiry_date = credit_card_expiry_date
        self.credit_card_type = credit_card_type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UInt64.self, forKey: .id)
        uid = try container.decode(String.self, forKey: .uid)
        credit_card_number = try container.decode(String.self, forKey: .credit_card_number)
        credit_card_expiry_date = try container.decode(String.self, forKey: .credit_card_expiry_date)
        credit_card_type = try container.decode(String.self, forKey: .credit_card_type)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case uid
        case credit_card_number
        case credit_card_expiry_date
        case credit_card_type
    }
}

