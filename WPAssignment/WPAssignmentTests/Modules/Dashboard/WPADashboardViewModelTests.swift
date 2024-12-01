//
//  WPADashboardViewModelTests.swift
//  WPAssignmentTests
//
//  Created by Karthick Mannarkudi Ramesh Kumar on 01/12/24.
//

import Foundation
import XCTest
@testable import WPAssignment

class WPADashboardViewModelTests: XCTestCase {
    
    var viewModel: WPADashboardViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = WPADashboardViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchTabItems() {
        // Given
        XCTAssertTrue(viewModel.tabItems.isEmpty, "Tab items should be empty before fetching")
        
        // When
        viewModel.fetchTabItems()
        
        // Then
        XCTAssertEqual(viewModel.tabItems.count, 2, "There should be two tab items after fetching")
        
        let firstTabItem = viewModel.tabItems.first
        XCTAssertEqual(firstTabItem?.title, WPAGenericConstants.TabBar.kCreditCardTabTitle, "First tab item title should match")
        XCTAssertEqual(firstTabItem?.tabImageName, WPAGenericConstants.TabBar.kCreditCardImageName, "First tab item image name should match")
        XCTAssertEqual(firstTabItem?.tabType, .creditCards, "First tab item type should be creditCards")
        
        let secondTabItem = viewModel.tabItems.last
        XCTAssertEqual(secondTabItem?.title, WPAGenericConstants.TabBar.kBookmarksTabTitle, "Second tab item title should match")
        XCTAssertEqual(secondTabItem?.tabImageName, WPAGenericConstants.TabBar.kBookmarkImageName, "Second tab item image name should match")
        XCTAssertEqual(secondTabItem?.tabType, .bookmarks, "Second tab item type should be bookmarks")
    }
}
