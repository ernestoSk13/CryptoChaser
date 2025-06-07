//
//  MainListTests.swift
//  CryptoChaserUITests
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import XCTest
@testable import CryptoChaser

final class MainListTests: XCTestCase {
    let app = XCUIApplication()
    private let collectionView = XCUIApplication().collectionViews[Constants.Accessibility.MainList.identifier]
    private let searchBar = XCUIApplication().searchFields[Constants.Accessibility.MainList.SearchBar.TextField.identifier]
    private let cancelButton = XCUIApplication().buttons["Cancel"]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
       
        app.launchEnvironment["TEST_MODE"] = "1"
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTableViewExists() throws {
        // Make sure the tableview exist
        XCTAssert(collectionView.waitForExistence(timeout: 1))
        // Make sure the mocked data has 20 elements
        XCTAssert(collectionView.cells.count > 0)
    }
    
    func testStellarCellExists() throws {
        let cellIdentifier = Constants.Accessibility.MainList.Row.identifier.replacingOccurrences(of: "$1", with: "stellar")
        let stellarCell = collectionView.cells[cellIdentifier]
        var maxScrolls = 10
        
        while !stellarCell.isHittable && maxScrolls > 0 {
            app.swipeUp()
            // We prevent scrolling forever
            maxScrolls -= 1
        }
        
        // If we found out cell, we'd like to check that the label and values are correct.
        XCTAssert(stellarCell.label == "Stellar")
        guard let cellValue = stellarCell.value as? String else {
            XCTFail("Unexpected value: \(type(of: stellarCell.value))")
            return
        }
        XCTAssert(cellValue == "$0.29")
    }
    
    func testSearchCurrency() throws {
        guard searchBar.exists else {
            XCTFail("Search bar not found")
            return
        }
        
        searchBar.tap()
        app.typeText("Hedera")
        
        let cellIdentifier = Constants.Accessibility.MainList.Row.identifier.replacingOccurrences(of: "$1", with: "hedera-hashgraph")
        let targetCell = collectionView.cells[cellIdentifier]
        
        XCTAssert(targetCell.exists)
        cancelButton.tap()
    }
    
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
