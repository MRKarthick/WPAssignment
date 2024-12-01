//
//  BookmarkViewModelTests.swift
//  WPAssignmentTests
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import XCTest
import Combine
@testable import WPAssignment

class WPAMockCreditCardService_Bookmark: WPACreditCardServiceProtocol {
    var fetchBookmarkedCardsResult: Result<[WPACreditCardDTO], Error> = .success([])
    
    func fetchCards(isForceFetch: Bool) -> AnyPublisher<[WPACreditCardDTO], Error> {
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func updateBookmark(forCardWithCcUid ccUid: String, withValue isBookmarked: Bool) {
        // To Do
    }
    
    func fetchBookmarkedCards() -> AnyPublisher<[WPACreditCardDTO], Error> {
        return Future { promise in
            promise(self.fetchBookmarkedCardsResult)
        }
        .eraseToAnyPublisher()
    }
}

class WPABookmarkViewModelTests: XCTestCase {
    var viewModel: WPABookmarksViewModel!
    var mockService: WPAMockCreditCardService_Bookmark!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = WPAMockCreditCardService_Bookmark()
        viewModel = WPABookmarksViewModel(creditCardService: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchBookmarkedCardsSuccess() {
        // Given
        let expectedCards = [WPACreditCardDTO(ccId: 1, ccUid: "99a59004-6f51-497d-b2ab-eb4952c0ac3e", ccNumber: "1212-1212-1212-1212", ccExpiryDate: "2027-12-01", ccType: "dankort", isBookmarked: true)]
        mockService.fetchBookmarkedCardsResult = .success(expectedCards)
        let expectation = XCTestExpectation(description: "Fetch Bookmarked Cards")

        // When
        viewModel.$groupedBookmarks
            .dropFirst()
            .sink { groupedBookmarks in
                // Then
                XCTAssertEqual(groupedBookmarks.count, 1)
                XCTAssertEqual(groupedBookmarks.first?.key, "dankort")
                XCTAssertEqual(groupedBookmarks.first?.value.count, 1)
                XCTAssertEqual(groupedBookmarks.first?.value.first?.isBookmarked, expectedCards.first?.isBookmarked)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchBookmarkedCards()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchBookmarkedCardsFailure() {
        // Given
        mockService.fetchBookmarkedCardsResult = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network Error"]))
        let expectation = XCTestExpectation(description: "Fetch Bookmarked Cards Failure")

        // When
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                // Then
                XCTAssertEqual(errorMessage, "Failed to fetch bookmarks: Network Error")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchBookmarkedCards()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
