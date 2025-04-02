//
//  MatchesHistoryTests.swift
//  TennisStarterTests
//
//  Created by ADRIAN SAVA on 19/03/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

import XCTest

final class MatchesHistoryTests: XCTestCase {
    
    var histroryScores: MatchesHistory!
    var mirror: Mirror!
    
    override func setUp() {
        super.setUp()
        histroryScores = MatchesHistory()
        mirror = Mirror(reflecting: histroryScores!)
    }
    
    override func tearDown() {
        super.tearDown()
    }



    func testMatchesHistoryInitialization() {
        let history = MatchesHistory()
        XCTAssertEqual(history.scores[0], [])
        XCTAssertEqual(history.scores[1], [])
        
        history.scores = [[6, 7, 6],  [4, 5, 2]]
        XCTAssertEqual(history.scores[0], [6, 7, 6])
        
    }


}
