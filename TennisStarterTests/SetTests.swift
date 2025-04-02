//
//  SetTests.swift
//  TennisStarterTests
//
//  Created by ADRIAN SAVA on 10/02/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

import XCTest

final class SetTests: XCTestCase {


    var game: Game!
    var set: Set!
    var mirror: Mirror!
    
    override func setUp() {
        super.setUp()
        game = Game()
        set = Set()
        mirror = Mirror(reflecting: game!)
        XCTAssertEqual(mirror.children.count, 2)
    }
    
    override func tearDown() {
        super.tearDown()
    }
        
    func setTieBreak() {
        for _ in 0..<6 {
            set.addGameToPlayer1()
            set.addGameToPlayer2()
        }      
    }
    
    func testMaxTwoInstanceVariables(){
        XCTAssertLessThanOrEqual(mirror.children.count, 2)
    }
    
    func testNotASubclass(){
        XCTAssertNil(mirror.superclassMirror)
    }
    
    func testZeroPoints(){
        XCTAssertEqual(set.getGamesP1(), 0, "P1 Games score correct with 0 points")
        XCTAssertEqual(set.getGamesP2(), 0, "P2 Games score correct with 0 points")
    }
    
    func testAddOneGame() {
        set.addGameToPlayer1()
        XCTAssertEqual(set.getGamesP1(), 1, "P1 Games score correct with 1 point")
        set.addGameToPlayer2()
        XCTAssertEqual(set.getGamesP2(), 1, "P1 Games score correct with 1 point")
    }
    
    func testAddPointToPlayer1() {
        setTieBreak()
        XCTAssertNotNil(set.tieBreak, "TieBreak should be initialized")

        guard let tieBreak = set.tieBreak else { return }        
        for _ in 0..<6 {
            set.addPointToPlayer1()
        }
        XCTAssertEqual(tieBreak.getPointsPlayer1(), 6, "Player 1 should have 6 points in TieBreak")

        set.addPointToPlayer1()

        XCTAssertNil(set.tieBreak, "TieBreak should be nil after player 1 wins")
        XCTAssertEqual(set.getGamesP1(), 0, "Games should be reset after TieBreak")
        XCTAssertEqual(set.getGamesP2(), 0, "Games should be reset after TieBreak")
    }
    
    func testAddPointToPlayer2() {
        setTieBreak()
        XCTAssertNotNil(set.tieBreak, "TieBreak should be initialized")

        guard let tieBreak = set.tieBreak else { return }
        for _ in 0..<6 {
            set.addPointToPlayer2()
        }
        XCTAssertEqual(tieBreak.getPointsPlayer2(), 6, "Player 1 should have 6 points in TieBreak")

        set.addPointToPlayer2()

        XCTAssertNil(set.tieBreak, "TieBreak should be nil after player 1 wins")
        XCTAssertEqual(set.getGamesP2(), 0, "Games should be reset after TieBreak")
        XCTAssertEqual(set.getGamesP1(), 0, "Games should be reset after TieBreak")
    }
  
    
    func testAddMultipleGames() {
        game = Game()
        set.addGameToPlayer1()
        set.addGameToPlayer1()
        set.addGameToPlayer1()
        XCTAssertEqual(set.getGamesP1(), 3, "P1 Games score correct with 3 point")
        set.addGameToPlayer2()
        set.addGameToPlayer2()
        set.addGameToPlayer2()
        set.addGameToPlayer2()
        XCTAssertEqual(set.getGamesP2(), 4, "P1 Games score correct with 3 point")
    }
    
    func testResetGames() {
        set.addGameToPlayer1()
        set.resetGames()
        XCTAssertEqual(set.getGamesP1(), 0, "P1 Games score correct with 0 points")
        set.addGameToPlayer2()
        set.addGameToPlayer2()
        set.resetGames()
        XCTAssertEqual(set.getGamesP2(), 0, "P2 Games score correct with 0 points")
    }
    
    func testGetGamesP1() {
        set.addGameToPlayer1()
        set.addGameToPlayer1()
        set.addGameToPlayer1()
        XCTAssertEqual(set.getGamesP1(), 3, "P2 Games score correct with 3 points")
    }
    
    func testGetGamesP2() {
        set.addGameToPlayer2()
        set.addGameToPlayer2()
        XCTAssertEqual(set.getGamesP2(), 2, "P2 Games score correct with 2 points")
    }
    
    func testCheckForTieBreak() {
        
        setTieBreak()
        
        XCTAssertTrue(set.checkForTieBreak(), "true")
    }
    
    
    func testIsTieBreakActive() {
        
        setTieBreak()
        XCTAssertTrue(set.checkForTieBreak(), "this is an actual tieBreak situation")
        
        set.addTieBreakWin()
        XCTAssertFalse(set.checkForTieBreak(), "this is not an actual tieBreak situation")
        
    }
    
    func testPlayer1WinsSet() {
        for _ in 0...6{
            set.addGameToPlayer1()
        }
        for _ in 0...4{
            set.addGameToPlayer2()
        }
        let result = set.checkForSetWin()
        XCTAssertTrue(result.0)
        XCTAssertEqual(result.1, 1)
    }
    
    func testPlayer2WinsSet() {
        for _ in 0...4{
            set.addGameToPlayer1()
        }
        for _ in 0...6{
            set.addGameToPlayer2()
        }
        let result = set.checkForSetWin()
        XCTAssertTrue(result.0)
        XCTAssertEqual(result.1, 2)
    }
    
    
    func testAddTieBreakWin() {
        for _ in 0...4{
            set.addGameToPlayer1()
        }
        for _ in 0...3{
            set.addGameToPlayer2()
        }
        
        set.tieBreak = TieBreak()
        set.currentServer = 1

        set.addTieBreakWin()

        XCTAssertEqual(set.getGamesP1(), 0)
        XCTAssertEqual(set.getGamesP2(), 0)
        XCTAssertNil(set.tieBreak)
        XCTAssertEqual(set.currentServer, 2)
    }
    
    func testSwitchServerTieBreakMultipleSituations() {
        set.tieBreak = TieBreak()
        set.currentServer = 1
        
        XCTAssertEqual(set.currentServer, 1)

        set.tieBreak?.pointsPlayed = 0
        set.switchServerTieBreak()
        XCTAssertEqual(set.currentServer, 1)

        set.tieBreak?.pointsPlayed = 1
        set.switchServerTieBreak()
        XCTAssertEqual(set.currentServer, 2)

        set.tieBreak?.pointsPlayed = 2
        set.switchServerTieBreak()
        XCTAssertEqual(set.currentServer, 2)

        set.tieBreak?.pointsPlayed = 3
        set.switchServerTieBreak()
        XCTAssertEqual(set.currentServer, 1)

        set.tieBreak?.pointsPlayed = 4
        set.switchServerTieBreak()
        XCTAssertEqual(set.currentServer, 1)

        set.tieBreak?.pointsPlayed = 5
        set.switchServerTieBreak()
        XCTAssertEqual(set.currentServer, 2)

    }
        
    func testAddGameWhenSetComplete() {
        for _ in 0..<6 { set.addGameToPlayer1() }
        for _ in 0..<6 { set.addGameToPlayer2() }
        XCTAssertTrue(set.checkForTieBreak())

        set.addGameToPlayer1()
        XCTAssertEqual(set.getGamesP1(), 6)
        set.addGameToPlayer2()
        XCTAssertEqual(set.getGamesP2(), 6)
    }
    
    func testServerSwitchAfterSetComplete() {
        for _ in 0..<6 { set.addGameToPlayer1() }
        for _ in 0..<4 { set.addGameToPlayer2() }

        XCTAssertEqual(set.getCurrentServer(), 1)
    }
    
    func testServerSwitchAfterEachGame() {
        set.addGameToPlayer1()
        XCTAssertEqual(set.getCurrentServer(), 2)

        set.addGameToPlayer2()
        XCTAssertEqual(set.getCurrentServer(), 1)
    }


    


}
