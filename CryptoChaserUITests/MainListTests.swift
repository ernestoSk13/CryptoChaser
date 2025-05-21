//
//  MainListTests.swift
//  CryptoChaserUITests
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import XCTest
@testable import CryptoChaser

final class MainListTests: XCTestCase {
    private let tableView = XCUIApplication().tables[Constants.Accessibility.MainList.identifier]
    private let searchBar = XCUIApplication().searchFields[Constants.Accessibility.MainList.SearchBar.TextField.identifier]
    private let cancelButton = XCUIApplication().buttons["Cancel"]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchEnvironment["UITEST_MODE"] = "1"
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTableViewExists() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITEST_MODE"] = "1"
        app.launch()

        // Make sure the tableview exist
        XCTAssert(tableView.waitForExistence(timeout: 1))
        // Make sure the mocked data has 20 elements
        XCTAssert(tableView.cells.count == 20)
    }
    
    func testStellarCellExists() throws {
        let app = XCUIApplication()
        app.launchEnvironment["UITEST_MODE"] = "1"
        app.launch()
        let cellIdentifier = Constants.Accessibility.MainList.Row.identifier.replacingOccurrences(of: "$1", with: "stellar")
        let stellarCell = tableView.cells[cellIdentifier]
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
        let app = XCUIApplication()
        app.launchEnvironment["UITEST_MODE"] = "1"
        app.launch()
        
        guard searchBar.exists else {
            XCTFail("Search bar not found")
            return
        }
        
        searchBar.tap()
        app.typeText("Hedera")
        
        let cellIdentifier = Constants.Accessibility.MainList.Row.identifier.replacingOccurrences(of: "$1", with: "hedera-hashgraph")
        let targetCell = tableView.cells[cellIdentifier]
        
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
