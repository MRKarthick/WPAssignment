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
    
    func testToggleBookmarkForUnbookmarkedCard() {
        // Given
        let card = WPACreditCardDTO(ccId: 1, ccUid: "99a59004-6f51-497d-b2ab-eb4952c0ac3e", ccNumber: "1212-1212-1212-1212", ccExpiryDate: "2027-12-01", ccType: "dankort", isBookmarked: false)
        viewModel.cardsDto = [card]
        viewModel.groupedCards = WPACreditCardDTO.groupAndSortCreditCards([card])
        
        // When
        viewModel.toggleBookmark(card: card)
        
        // Then
        XCTAssertTrue(mockService.updateBookmarkCalled)
        XCTAssertTrue(viewModel.cardsDto.first?.isBookmarked ?? false)
        XCTAssertEqual(viewModel.groupedCards.first?.value.first?.isBookmarked, true)
    }
    
    func testToggleBookmarkForBookmarkedCard() {
        // Given
        let card = WPACreditCardDTO(ccId: 1, ccUid: "99a59004-6f51-497d-b2ab-eb4952c0ac3e", ccNumber: "1212-1212-1212-1212", ccExpiryDate: "2027-12-01", ccType: "dankort", isBookmarked: true)
        viewModel.cardsDto = [card]
        viewModel.groupedCards = WPACreditCardDTO.groupAndSortCreditCards([card])
        
        // When
        viewModel.toggleBookmark(card: card)
        
        // Then
        XCTAssertTrue(mockService.updateBookmarkCalled)
        XCTAssertFalse(viewModel.cardsDto.first?.isBookmarked ?? true)
        XCTAssertEqual(viewModel.groupedCards.first?.value.first?.isBookmarked, false)
    }
    
    func testToggleBookmarkUpdatesGroupedCards() {
        // Given
        let card1 = WPACreditCardDTO(ccId: 1, ccUid: "99a59004-6f51-497d-b2ab-eb4952c0ac3e", ccNumber: "1212-1212-1212-1212", ccExpiryDate: "2027-12-01", ccType: "dankort", isBookmarked: false)
        let card2 = WPACreditCardDTO(ccId: 2, ccUid: "88b59004-6f51-497d-b2ab-eb4952c0ac3e", ccNumber: "3434-3434-3434-3434", ccExpiryDate: "2028-12-01", ccType: "visa", isBookmarked: true)
        viewModel.cardsDto = [card1, card2]
        viewModel.groupedCards = WPACreditCardDTO.groupAndSortCreditCards([card1, card2])
        
        // When
        viewModel.toggleBookmark(card: card1)
        
        // Then
        XCTAssertTrue(viewModel.cardsDto.first?.isBookmarked ?? false)
        XCTAssertEqual(viewModel.groupedCards.count, 2)
        XCTAssertEqual(viewModel.groupedCards.first(where: { $0.key == "dankort" })?.value.first?.isBookmarked, true)
    }
}
