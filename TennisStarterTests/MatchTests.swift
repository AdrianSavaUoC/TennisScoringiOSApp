//
//  MatchTests.swift
//  TennisStarterTests
//
//  Created by ADRIAN SAVA on 13/02/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

import XCTest

final class MatchTests: XCTestCase {

    var tieBreak: TieBreak?
    var game: Game?
    var set: Set?
    var match: Match?
    var mirror: Mirror!
    
    override func setUp() {
        super.setUp()
        game = Game()
        set = Set()
        match = Match()
        mirror = Mirror(reflecting: set!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testAddGametToPlayer1() {        
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()
        XCTAssertEqual(match?.getSetsP1(), 4)
        
    }
    
    func testAddGametToPlayer2() {
        match?.addSetToPlayer2()
        match?.addSetToPlayer2()
        match?.addSetToPlayer2()
        match?.addSetToPlayer2()
        match?.addSetToPlayer2()
        XCTAssertEqual(match?.getSetsP2(), 5)
    }
    
    
    func testAddPointToPlayer1_InitialGame() {
        match?.addPointToPlayer1()
        XCTAssertEqual(match?.currentGame?.getPointsPlayer1(), 1)
    }

    func testAddPointToPlayer1_GameWon() {
        match?.addPointToPlayer1()
        match?.addPointToPlayer1()
        match?.addPointToPlayer1()
        match?.addPointToPlayer1()
        XCTAssertEqual(match?.currentSet.getGamesP1(), 1)
        XCTAssertEqual(match?.currentGame?.getPointsPlayer1(), 0)
    }
    
    func testAddPointToPlayer1_SetWon() {
        for _ in 0..<4 { //Win 1 game
            match?.addPointToPlayer1()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer1()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer1()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer1()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer1()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer1()
        }
        XCTAssertEqual(match?.getSetsP1(), 1)
    }
    
    func testStartNewGame() {
        match?.startNewGame()
        XCTAssertNotNil(game)
        game = nil
        XCTAssertNil(game)
    }
    
    func testAddPointToPlayer2_InitialGame() {
        match?.addPointToPlayer2()
        XCTAssertEqual(match?.currentGame?.getPointsPlayer2(), 1)
    }

    func testAddPointToPlayer2_GameWon() {
        match?.addPointToPlayer2()
        match?.addPointToPlayer2()
        match?.addPointToPlayer2()
        match?.addPointToPlayer2()
        XCTAssertEqual(match?.currentSet.getGamesP2(), 1)
        XCTAssertEqual(match?.currentGame?.getPointsPlayer2(), 0)
    }

    func testAddPointToPlayer2_SetWon() {
        for _ in 0..<4 {
            match?.addPointToPlayer2()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer2()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer2()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer2()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer2()
        }
        for _ in 0..<4 {
            match?.addPointToPlayer2()
        }
        XCTAssertEqual(match?.getSetsP2(), 1)
    }
    
    func testGetFinalScore() {
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()

        let (finalP1, finalP2) = match?.getFinalScore() ?? ([], [])

        XCTAssertEqual(finalP1.count, 3)
        XCTAssertEqual(finalP2.count, 3)
    }

    func testMatchWinner() {
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()

        XCTAssertTrue(((match?.matchWinner()) != nil), "true")

        match = Match()
        match?.addSetToPlayer2()
        match?.addSetToPlayer2()
        match?.addSetToPlayer2()

        XCTAssertTrue(((match?.matchWinner()) != nil), "false")

        match = Match()
        match?.addSetToPlayer1()
        match?.addSetToPlayer2()

        XCTAssertTrue((match?.matchWinner() != nil), "false")
    }
    
    func testGetWinner() {
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()

        XCTAssertEqual(match?.getWinner(), "Player 1")

        match = Match()
        match?.addSetToPlayer2()
        match?.addSetToPlayer2()
        match?.addSetToPlayer2()

        XCTAssertEqual(match?.getWinner(), "Player 2")

        match = Match()
        XCTAssertEqual(match?.getWinner(), "")
    }


    func testMatchPoint() {
        match?.addSetToPlayer1()
        match?.addSetToPlayer1()
        
        XCTAssertTrue(((match?.matchPoint()) != nil), "false")

        match?.addSetToPlayer2()
        match?.addSetToPlayer2()
        
        XCTAssertTrue(((match?.matchPoint()) != nil), "false")

        match?.addSetToPlayer1()
        
        XCTAssertTrue(((match?.matchPoint()) != nil), "true")
    }

    func testEndTieBreak() {
        match?.currentSet.tieBreak = TieBreak()

        match?.endTieBreak()

        XCTAssertEqual(match?.getSetsP1(), 0)
        XCTAssertNil(match?.currentSet.tieBreak)

        match?.currentSet.tieBreak = TieBreak()
        match?.endTieBreak()

        XCTAssertEqual(match?.getSetsP2(), 0)
        XCTAssertNil(match?.currentSet.tieBreak)
    }
    
    func testDetermineStartingServer() {
        XCTAssertEqual(match?.determineStartingServer(), 1)

        match?.addSetToPlayer1()
        XCTAssertEqual(match?.determineStartingServer(), 2)

        match?.addSetToPlayer2()
        XCTAssertEqual(match?.determineStartingServer(), 1)
    }


}

