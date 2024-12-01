//
//  WPACreditCardViewModelTests.swift
//  WPAssignmentTests
//
//  Created by EdgeCaseDesigns on 01/12/24.
//

import XCTest
import Combine
@testable import WPAssignment

class WPAMockCreditCardService: WPACreditCardServiceProtocol {
    func fetchBookmarkedCards() -> AnyPublisher<[WPAssignment.WPACreditCardDTO], any Error> {
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    var fetchCardsResult: Result<[WPACreditCardDTO], Error> = .success([])
    var updateBookmarkCalled = false
    
    func fetchCards(isForceFetch: Bool) -> AnyPublisher<[WPACreditCardDTO], Error> {
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
        let expectedCards = [WPACreditCardDTO(ccId: 1, ccUid: "99a59004-6f51-497d-b2ab-eb4952c0ac3e", ccNumber: "1212-1212-1212-1212", ccExpiryDate: "2027-12-01", ccType: "dankort")]
        mockService.fetchCardsResult = .success(expectedCards)
        
        let expectation = XCTestExpectation(description: "Fetch cards")
        
        viewModel.$groupedCards
            .dropFirst()
            .sink { groupedCards in
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
        mockService.fetchCardsResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
        
        let expectation = XCTestExpectation(description: "Fetch cards failure")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Failed to fetch cards: Network error")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchCards()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testToggleBookmark() {
        let card = WPACreditCardDTO(ccId: 1, ccUid: "99a59004-6f51-497d-b2ab-eb4952c0ac3e", ccNumber: "1212-1212-1212-1212", ccExpiryDate: "2027-12-01", ccType: "dankort")
        
        viewModel.toggleBookmark(card: card)
        
        XCTAssertTrue(mockService.updateBookmarkCalled)
    }
}
