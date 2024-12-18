//
//  WPACreditCardServicesTests.swift
//  WPAssignmentTests
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import Foundation
import XCTest
import Combine
@testable import WPAssignment

class WPAMockAPIService: WPAAPIServiceProtocol {
    var result: Result<[WPACreditCardModel], Error>?
    
    func fetchData<T: Decodable>(from urlString: String) -> Future<T, Error> {
        return Future { promise in
            switch self.result {
            case .success(let data as T):
                promise(.success(data))
            case .failure(let error):
                promise(.failure(error))
            default:
                promise(.failure(APIError.noData)) // Default to no data error if result is nil
            }
        }
    }
}

class MockPersistence: WPACreditCardPersistenceProtocol {
    var saveResult: Result<Void, WPACreditCardPersistenceError> = .success(())
    var fetchResult: Result<[WPACreditCardEntity], WPACreditCardPersistenceError> = .success([])
    var updateResult: Result<Void, WPACreditCardPersistenceError> = .success(())
    
    func saveCard(_ creditCard: WPACreditCardEntity) -> Result<Void, WPACreditCardPersistenceError> {
        return saveResult
    }
    
    func saveCards(_ creditCards: [WPAssignment.WPACreditCardEntity]) -> Result<Void, WPAssignment.WPACreditCardPersistenceError> {
        return saveResult
    }
    
    func fetchCreditCards() -> Result<[WPACreditCardEntity], WPACreditCardPersistenceError> {
        return fetchResult
    }
    
    func deleteAllCreditCards(excludingBookmarks: Bool) -> Result<Void, WPACreditCardPersistenceError> {
        return .success(())
    }
    
    func updateBookmark(forCardWithCcUid ccUid: String, withValue isBookmarked: Bool) -> Result<Void, WPACreditCardPersistenceError> {
        return updateResult
    }
    
    func fetchBookmarkedCreditCards() -> Result<[WPACreditCardEntity], WPACreditCardPersistenceError> {
        return fetchResult
    }
}

class WPACreditCardServiceTests: XCTestCase {
    var service: WPACreditCardService!
    var mockAPIService: WPAMockAPIService!
    var mockPersistence: MockPersistence!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockAPIService = WPAMockAPIService()
        mockPersistence = MockPersistence()
        service = WPACreditCardService(apiService: mockAPIService, persistence: mockPersistence)
    }

    override func tearDown() {
        service = nil
        mockAPIService = nil
        mockPersistence = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchCardsFailure() {
        // Given: A mock API service set to fail with no data error
        mockAPIService.result = .failure(APIError.noData)
        let expectation = self.expectation(description: "FetchCards")

        // When: Fetching cards from the service
        service.fetchCards(isForceFetch: true)
            .sink(receiveCompletion: { completion in
                // Then: The operation should fail with a no data error
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? APIError, APIError.noData)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                // Then: No cards should be received
                XCTFail("Expected failure, got success")
            })
            .store(in: &cancellables)

        // Then: Wait for expectations to be fulfilled
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testUpdateBookmarkSuccess() {
        mockPersistence.updateResult = .success(())
        
        service.updateBookmark(forCardWithCcUid: "123", withValue: true)
    }

    func testUpdateBookmarkFailure() {
        mockPersistence.updateResult = .failure(.cardNotFound("123"))
        
        service.updateBookmark(forCardWithCcUid: "123", withValue: true)        
    }
}
