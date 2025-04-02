//
//  HistoryViewControllerTests.swift
//  TennisStarterTests
//
//  Created by ADRIAN SAVA on 19/03/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

import XCTest


final class HistoryViewControllerTests: XCTestCase {
    
    var viewController: HistoryViewController!
    
    override func setUp() {
        super.setUp()
        viewController = HistoryViewController()
        viewController.loadView()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(viewController, "ViewController should be initialized")
        XCTAssertNotNil(viewController.scores_list, "Scores list should be initialized")
        XCTAssertNotNil(viewController.pathURL, "Path URL should be valid")
    }
    
    func testAddToHistAddsMatch() {
        viewController.finalScore = ([6, 7, 6], [4, 5, 2])
        viewController.addToHist()
        
        XCTAssertEqual(viewController.scores_list.count, 1, "Scores list should contain one match")
        XCTAssertEqual(viewController.scores_list.first?.scores[0], [6, 7, 6], "Player 1 scores should be correct")
        XCTAssertEqual(viewController.scores_list.first?.scores[1], [4, 5, 2], "Player 2 scores should be correct")
    }
    
    func testDefaultState() {
        XCTAssertTrue(viewController.scores_list.isEmpty, "Scores list should be empty initially")
        XCTAssertTrue(viewController.finalScore.0.isEmpty, "FinalScore first array should be empty initially")
        XCTAssertTrue(viewController.finalScore.1.isEmpty, "FinalScore second array should be empty initially")
    }
    
    func testAddToHistWithEmptyScores() {
        viewController.finalScore = ([], [])
        viewController.addToHist()
        
        XCTAssertTrue(viewController.scores_list.isEmpty, "Scores list should remain empty when finalScore is empty")
    }

    
    func testFinalScoreConversion() {
        viewController.finalScore = ([6, "7", 6.0], ["4", 5, 2])
        viewController.addToHist()

        XCTAssertEqual(viewController.scores_list.first?.scores[0], [6], "Player 1 scores should only include valid Int values")
        XCTAssertEqual(viewController.scores_list.first?.scores[1], [5, 2], "Player 2 scores should only include valid Int values")
    }
        
    func testAddMultipleMatches() {
        viewController.finalScore = ([6, 7], [4, 5])
        viewController.addToHist()
        
        viewController.finalScore = ([3, 2], [6, 4])
        viewController.addToHist()
        
        XCTAssertEqual(viewController.scores_list.count, 2, "Scores list should contain two matches")
    }
    
    func testTableViewNumberOfRows() {
        let tableView = UITableView()
        viewController.tableViewHistory = tableView
        
        viewController.finalScore = ([6, 7], [4, 5])
        viewController.addToHist()
        
        viewController.finalScore = ([3, 2], [6, 4])
        viewController.addToHist()
        
        XCTAssertEqual(viewController.tableView(viewController.tableViewHistory, numberOfRowsInSection: 0), 2, "Table view should display two matches")
    }
    
}
