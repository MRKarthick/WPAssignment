//
//  WPOCreditCardDTOTests.swift
//  WPAssignmentTests
//
//  Created by EdgeCaseDesigns on 02/12/24.
//

import Foundation
import XCTest
@testable import WPAssignment

final class WPACreditCardDTOTests: XCTestCase {
    func testGroupAndSortCreditCards() {
        // Given
        let card1 = WPACreditCardDTO(ccId: 1, ccUid: "uid1", ccNumber: "1234", ccExpiryDate: "12/24", ccType: "Visa")
        let card2 = WPACreditCardDTO(ccId: 2, ccUid: "uid2", ccNumber: "5678", ccExpiryDate: "11/23", ccType: "MasterCard")
        let card3 = WPACreditCardDTO(ccId: 3, ccUid: "uid3", ccNumber: "9101", ccExpiryDate: "10/22", ccType: "Visa")
        let card4 = WPACreditCardDTO(ccId: 4, ccUid: "uid4", ccNumber: "1121", ccExpiryDate: "09/21", ccType: "Amex")
        
        let cards = [card1, card2, card3, card4]
        
        // When
        let groupedAndSortedCards = WPACreditCardDTO.groupAndSortCreditCards(cards)
        
        // Then
        XCTAssertEqual(groupedAndSortedCards.count, 3, "There should be 3 groups of credit cards.")
        
        XCTAssertEqual(groupedAndSortedCards[0].key, "Amex", "The first group should be Amex.")
        XCTAssertEqual(groupedAndSortedCards[0].value.count, 1, "There should be 1 Amex card.")
        
        XCTAssertEqual(groupedAndSortedCards[1].key, "MasterCard", "The second group should be MasterCard.")
        XCTAssertEqual(groupedAndSortedCards[1].value.count, 1, "There should be 1 MasterCard card.")
        
        XCTAssertEqual(groupedAndSortedCards[2].key, "Visa", "The third group should be Visa.")
        XCTAssertEqual(groupedAndSortedCards[2].value.count, 2, "There should be 2 Visa cards.")
    }
}
