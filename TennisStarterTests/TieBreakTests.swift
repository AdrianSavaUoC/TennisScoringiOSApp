//
//  TieBreakTests.swift
//  TennisStarterTests
//
//  Created by ADRIAN SAVA on 13/02/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

import XCTest

final class TieBreakTests: XCTestCase {

    var tieBreak: TieBreak!
    var mirror: Mirror!
    
    override func setUp() {
        super.setUp()
        tieBreak = TieBreak()
        mirror = Mirror(reflecting: tieBreak!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddPointToPlayer1() {
        tieBreak.addPointToPlayer1()
        tieBreak.addPointToPlayer1()
        XCTAssertEqual(tieBreak.getPointsPlayer1(), 2)
    }
    
    
    func testAddPointToPlayer2() {
        tieBreak.addPointToPlayer2()
        tieBreak.addPointToPlayer2()
        XCTAssertFalse(tieBreak.gamePointForPlayer2(), "false")

        tieBreak.addPointToPlayer2()
        tieBreak.addPointToPlayer2()
        tieBreak.addPointToPlayer2()
        XCTAssertEqual(tieBreak.getPointsPlayer2(), 5)
    }
    
    func testComplete () {
        
        tieBreak.addPointToPlayer1()
        XCTAssertFalse(tieBreak.complete(), "true")
        for _ in 0...6{
            tieBreak.addPointToPlayer1()
        }
        
        tieBreak = TieBreak()
        tieBreak.addPointToPlayer2()
        XCTAssertFalse(tieBreak.complete(), "true")
        for _ in 0...5{
            tieBreak.addPointToPlayer2()
        }
        XCTAssertTrue(tieBreak.complete(), "true")
        
    }
    
    func testPlayer1WonTieBreak() {
        for _ in 0...6{
            tieBreak.addPointToPlayer1()
        }
        XCTAssertTrue(tieBreak.player1WonTieBreak(), "true")
    }
    
    func testPlayer2WonTieBreak() {
        for _ in 0...6{
            tieBreak.addPointToPlayer2()
        }
        XCTAssertTrue(tieBreak.player2WonTieBreak(), "true")
    }
    
    func testGamePointForPlayer1() {
        for _ in 0...6{
            tieBreak.addPointToPlayer1()
        }
        XCTAssertFalse(tieBreak.gamePointForPlayer1(), "false")
        
        tieBreak = TieBreak()
        for _ in 0...5{
            tieBreak.addPointToPlayer1()
        }
        tieBreak.addPointToPlayer2()
        XCTAssertTrue(tieBreak.gamePointForPlayer1(), "true")
        
        tieBreak = TieBreak()
        tieBreak.addPointToPlayer1()
        tieBreak.addPointToPlayer1()
        tieBreak.addPointToPlayer2()
        XCTAssertFalse(tieBreak.gamePointForPlayer1(), "false")
    }
    
    
    func testGamePointForPlayer2() {
        for _ in 0...6{
            tieBreak.addPointToPlayer2()
        }
        XCTAssertFalse(tieBreak.gamePointForPlayer2(), "false")
        
        tieBreak = TieBreak()
        for _ in 0...5{
            tieBreak.addPointToPlayer2()
        }
        tieBreak.addPointToPlayer1()
        XCTAssertTrue(tieBreak.gamePointForPlayer2(), "true")
        
        tieBreak = TieBreak()
        tieBreak.addPointToPlayer1()
        tieBreak.addPointToPlayer2()
        XCTAssertFalse(tieBreak.gamePointForPlayer1(), "false")

    }
    



}
