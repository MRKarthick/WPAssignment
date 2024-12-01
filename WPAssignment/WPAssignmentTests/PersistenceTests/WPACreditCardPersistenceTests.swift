//
//  PersistenceTests.swift
//  WPAssignmentTests
//
//  Created by EdgeCaseDesigns on 01/12/24.
//

import Foundation
import SwiftData
import XCTest
@testable import WPAssignment

final class WPACreditCardPersistenceTests: XCTestCase {
    
    var persistence: WPACreditCardPersistence!
    var mockContainer: ModelContainer!
    
    @MainActor
    override func setUp() {
        super.setUp()
        // Given: A temporary model container with mock data
        mockContainer = ModelContainer.temporary(entities: WPACreditCardEntity.self)
        persistence = WPACreditCardPersistence(container: mockContainer)
    }
    
    @MainActor
    override func tearDown() {
        persistence = nil
        mockContainer = nil
        super.tearDown()
    }
    
    @MainActor
    func testSaveCard() {
        // Given: A new credit card entity
        let creditCard = WPACreditCardEntity(ccId: 1, ccUid: "123", ccNumber: "4111111111111111", ccExpiryDate: "12/25", ccType: "Visa")
        
        // When: Saving the credit card
        let result = persistence.saveCard(creditCard)
        
        // Then: The save operation should succeed
        switch result {
        case .success:
            XCTAssertTrue(true)
        case .failure(let error):
            XCTFail("Save failed with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func testFetchCreditCards() {
        // Given: A saved credit card entity
        let creditCard = WPACreditCardEntity(ccId: 1, ccUid: "123", ccNumber: "4111111111111111", ccExpiryDate: "12/25", ccType: "Visa")
        _ = persistence.saveCard(creditCard)
        
        // When: Fetching all credit cards
        let result = persistence.fetchCreditCards()
        
        // Then: The fetch operation should return the saved credit card
        switch result {
        case .success(let cards):
            XCTAssertEqual(cards.count, 1)
            XCTAssertEqual(cards.first?.ccUid, "123")
        case .failure(let error):
            XCTFail("Fetch failed with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func testDeleteAllCreditCards() {
        // Given: A saved credit card entity
        let creditCard = WPACreditCardEntity(ccId: 1, ccUid: "123", ccNumber: "4111111111111111", ccExpiryDate: "12/25", ccType: "Visa")
        _ = persistence.saveCard(creditCard)
        
        // When: Deleting all credit cards
        let result = persistence.deleteAllCreditCards()
        
        // Then: The delete operation should succeed and no cards should remain
        switch result {
        case .success:
            let fetchResult = persistence.fetchCreditCards()
            switch fetchResult {
            case .success(let cards):
                XCTAssertEqual(cards.count, 0)
            case .failure(let error):
                XCTFail("Fetch after delete failed with error: \(error.localizedDescription)")
            }
        case .failure(let error):
            XCTFail("Delete failed with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func testUpdateBookmark() {
        // Given: A saved credit card entity
        let creditCard = WPACreditCardEntity(ccId: 1, ccUid: "123", ccNumber: "4111111111111111", ccExpiryDate: "12/25", ccType: "Visa")
        _ = persistence.saveCard(creditCard)
        
        // When: Updating the bookmark status
        let result = persistence.updateBookmark(forCardWithCcUid: "123", withValue: true)
        
        // Then: The update operation should succeed and the card should be bookmarked
        switch result {
        case .success:
            let fetchResult = persistence.fetchBookmarkedCreditCards()
            switch fetchResult {
            case .success(let cards):
                XCTAssertEqual(cards.count, 1)
                XCTAssertTrue(cards.first?.isBookmarked ?? false)
            case .failure(let error):
                XCTFail("Fetch bookmarked cards failed with error: \(error.localizedDescription)")
            }
        case .failure(let error):
            XCTFail("Update bookmark failed with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func testFetchBookmarkedCreditCards() {
        // Given: A saved and bookmarked credit card entity
        let creditCard = WPACreditCardEntity(ccId: 1, ccUid: "123", ccNumber: "4111111111111111", ccExpiryDate: "12/25", ccType: "Visa", isBookmarked: true)
        _ = persistence.saveCard(creditCard)
        
        // When: Fetching bookmarked credit cards
        let result = persistence.fetchBookmarkedCreditCards()
        
        // Then: The fetch operation should return the bookmarked credit card
        switch result {
        case .success(let cards):
            XCTAssertEqual(cards.count, 1)
            XCTAssertTrue(cards.first?.isBookmarked ?? false)
        case .failure(let error):
            XCTFail("Fetch bookmarked cards failed with error: \(error.localizedDescription)")
        }
    }
}
