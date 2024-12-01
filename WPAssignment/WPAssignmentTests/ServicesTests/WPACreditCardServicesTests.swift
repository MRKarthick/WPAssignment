//
//  WPACreditCardServicesTests.swift
//  WPAssignmentTests
//
//  Created by EdgeCaseDesigns on 01/12/24.
//

import Foundation
import XCTest
import Combine
@testable import WPAssignment

class MockAPIService: APIServiceProtocol {
    var result: Result<[WPACreditCardModel], Error>?
    
    func fetchData<T: Decodable>(from urlString: String) -> Future<T, Error> {
        let mockData = """
        [
            {
                "id": 1,
                "uid": "99887766",
                "credit_card_number": "1212-1221-1121-1234",
                "credit_card_expiry_date": "2027-12-01",
                "credit_card_type": "dankort"
            }
        ]
        """.data(using: .utf8)!
        
        return Future { promise in
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: mockData)
                promise(.success(decodedData))
            } catch {
                promise(.failure(error))
            }
        }
    }
}

class MockPersistence: WPACreditCardPersistenceProtocol {
    var saveResult: Result<Void, CreditCardPersistenceError> = .success(())
    var fetchResult: Result<[WPACreditCardEntity], CreditCardPersistenceError> = .success([])
    var updateResult: Result<Void, CreditCardPersistenceError> = .success(())
    
    func saveCard(_ creditCard: WPACreditCardEntity) -> Result<Void, CreditCardPersistenceError> {
        return saveResult
    }
    
    func fetchCreditCards() -> Result<[WPACreditCardEntity], CreditCardPersistenceError> {
        return fetchResult
    }
    
    func deleteAllCreditCards(excludingBookmarks: Bool) -> Result<Void, CreditCardPersistenceError> {
        return .success(())
    }
    
    func updateBookmark(forCardWithCcUid ccUid: String, withValue isBookmarked: Bool) -> Result<Void, CreditCardPersistenceError> {
        return updateResult
    }
    
    func fetchBookmarkedCreditCards() -> Result<[WPACreditCardEntity], CreditCardPersistenceError> {
        return fetchResult
    }
}

class WPACreditCardServiceTests: XCTestCase {
    var service: WPACreditCardService!
    var mockAPIService: MockAPIService!
    var mockPersistence: MockPersistence!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
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

    func testFetchCardsSuccess() {
        let mockModels = [WPACreditCardModel(id: 1, uid: "99887766", creditCardNumber: "1212-1221-1121-1234", creditCardExpirydate: "2027-12-01", creditCardType: "dankort")]
        mockAPIService.result = .success(mockModels)
        
        let expectation = self.expectation(description: "FetchCards")
        
        service.fetchCards(isForceFetch: true)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, got failure")
                }
            }, receiveValue: { cards in
                XCTAssertEqual(cards.count, 1)
                XCTAssertEqual(cards.first?.ccUid, "99887766")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchCardsFailure() {
        mockAPIService.result = .failure(APIError.noData)
        
        let expectation = self.expectation(description: "FetchCards")
        
        service.fetchCards(isForceFetch: true)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? APIError, APIError.noData)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, got success")
            })
            .store(in: &cancellables)
        
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
