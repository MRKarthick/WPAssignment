//
//  WPAServiceTests.swift
//  WPAssignmentTests
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import XCTest
import Combine
@testable import WPAssignment

class MockSession: NetworkSession {
    var data: Data?
    var error: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, nil, error)
        return URLSession.shared.dataTask(with: url) // Return a dummy task
    }
}

class WPAServiceTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    
    func testFetchDataSuccess() {
        let mockSession = MockSession()
        let testData = "{\"key\":\"value\"}".data(using: .utf8)!
        mockSession.data = testData
        
        let service = WPAService(session: mockSession)
        
        let expectation = self.expectation(description: "FetchData")
        
        service.fetchData(from: "https://example.com")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, got failure")
                }
            }, receiveValue: { (result: [String: String]) in
                XCTAssertEqual(result["key"], "value")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchDataFailure() {
        let mockSession = MockSession()
        mockSession.error = APIError.noData
        
        let service = WPAService(session: mockSession)
        
        let expectation = self.expectation(description: "FetchData")
        
        service.fetchData(from: "https://example.com")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? APIError, APIError.noData)
                    expectation.fulfill()
                }
            }, receiveValue: { (_: [String: String]) in
                XCTFail("Expected failure, got success")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
