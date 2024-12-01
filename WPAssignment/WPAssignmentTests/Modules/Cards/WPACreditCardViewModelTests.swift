//
//  WPACreditCardViewModelTests.swift
//  WPAssignmentTests
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import XCTest
import Combine
@testable import WPAssignment

class WPAMockCreditCardService: WPACreditCardServiceProtocol {
    var fetchCardsResult: Result<[WPACreditCardDTO], Error> = .success([])
    var updateBookmarkCalled = false
    
    func fetchBookmarkedCards() -> AnyPublisher<[WPAssignment.WPACreditCardDTO], any Error> {
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchCards(isForceFetch: Bool, size: Int) -> AnyPublisher<[WPACreditCardDTO], Error> {
        return fetchCardsResult.publisher.eraseToAnyPublisher()
    }
    
    func updateBookmark(forCardWithCcUid ccUid: String, withValue value: Bool) {
        updateBookmarkCalled = true
    }
}

class WPACreditCardViewModelTests: XCTestCase {
    var viewModel: WPACreditCardViewModel!
    var mockService: WPAMockCreditCardService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = WPAMockCreditCardService()
        viewModel = WPACreditCardViewModel(cardService: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchCardsSuccess() {
        // Given
        let expectedCards = [WPACreditCardDTO(ccId: 1, ccUid: "99a59004-6f51-497d-b2ab-eb4952c0ac3e", ccNumber: "1212-1212-1212-1212", ccExpiryDate: "2027-12-01", ccType: "dankort")]
        mockService.fetchCardsResult = .success(expectedCards)
        let expectation = XCTestExpectation(description: "Fetch cards")

        // When
        viewModel.$groupedCards
            .dropFirst()
            .sink { groupedCards in
                // Then
                XCTAssertEqual(groupedCards.count, 1)
                XCTAssertEqual(groupedCards.first?.key, "dankort")
                XCTAssertEqual(groupedCards.first?.value, expectedCards)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCards()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchCardsFailure() {
        // Given
        mockService.fetchCardsResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
        let expectation = XCTestExpectation(description: "Fetch cards failure")

        // When
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                // Then
                XCTAssertEqual(errorMessage, "Failed to fetch cards: Network error")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCards()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testToggleBookmark() {
        // Given
        let card = WPACreditCardDTO(ccId: 1, ccUid: "99a59004-6f51-497d-b2ab-eb4952c0ac3e", ccNumber: "1212-1212-1212-1212", ccExpiryDate: "2027-12-01", ccType: "dankort")
        
        // When
        viewModel.toggleBookmark(card: card)
        
        // Then
        XCTAssertTrue(mockService.updateBookmarkCalled)
    }
}
