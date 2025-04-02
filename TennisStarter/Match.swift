//
//  Match.swift
//  TennisStarter
//
//  Created by ADRIAN SAVA on 09/02/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//


class Match {
    private var player1Sets = 0
    private var player2Sets = 0
    var currentSet = Set()
    var currentGame: Game?
    var tieBreak: TieBreak?
    var winner: String?
    
    
    private var previousSetsP1: [Int] = []
    private var previousSetsP2: [Int] = []
    private var finalScoreP1: [Int] = []
    private var finalScoreP2: [Int] = []
    
    init() {
        startNewSet()
    }
    
    func addSetToPlayer1() {
        
        if let tieBreak = currentSet.tieBreak {
            previousSetsP1.append(tieBreak.getPointsPlayer1())
            previousSetsP2.append(tieBreak.getPointsPlayer2())
        } else {
            previousSetsP1.append(currentSet.getGamesP1())
            previousSetsP2.append(currentSet.getGamesP2())
        }
        player1Sets += 1
        if checkForMatchWin() {
        } else {}
    }
    
    func addSetToPlayer2() {
        if let tieBreak = currentSet.tieBreak {
            previousSetsP1.append(tieBreak.getPointsPlayer1())
            previousSetsP2.append(tieBreak.getPointsPlayer2())
        } else {
            previousSetsP1.append(currentSet.getGamesP1())
            previousSetsP2.append(currentSet.getGamesP2())
        }
        player2Sets += 1
        if checkForMatchWin() {
        } else {}
    }
    
    func checkForMatchWin() -> Bool {
        if player1Sets == 3 || player2Sets == 3 {
            if finalScoreP1.isEmpty && finalScoreP2.isEmpty {
                finalScoreP1 = getPreviousSetsP1()
                finalScoreP2 = getPreviousSetsP2()
            }
            print("Match Over! Winner: \(getWinner())")
            return true
        } else {
            currentSet = Set()
            currentGame = Game()
            return false
        }
    }
    
    func addPointToPlayer1() {
        currentSet.addPointToPlayer1()
        currentGame?.addPointToPlayer1()
        
        if currentGame?.player1Won() == true {
            currentSet.addGameToPlayer1()
            currentGame = Game()
            
            let currentServer = currentSet.getCurrentServer()
            print("Current Server: Player \(currentServer)")
        }
        
        if currentSet.complete() {
            if currentSet.player1WonSet() {
                addSetToPlayer1()
            } else {
                addSetToPlayer2()
            }
            startNewSet()
        }
    }
    
    func addPointToPlayer2() {
        currentSet.addPointToPlayer2()
        currentGame?.addPointToPlayer2()
        
        if currentGame?.player2Won() == true {
            currentSet.addGameToPlayer2()
            currentGame = Game()
            let currentServer = currentSet.getCurrentServer()
            print("Current Server: Player \(currentServer)")
        }
        
        if currentSet.complete() {
            if currentSet.player2WonSet() {
                addSetToPlayer2()
            } else {
                addSetToPlayer1()
            }
            startNewSet()
        }
    }
    
    func startNewSet() {
        let startingServer = determineStartingServer()
        currentSet = Set(startingServer: startingServer)
        currentGame = Game()
        print("Starting new set. Server: Player \(startingServer)")
    }
    
    func determineStartingServer() -> Int {
        let totalSetsPlayed = player1Sets + player2Sets
        return (totalSetsPlayed % 2 == 0) ? 1 : 2
    }
    
    func getSetsP1() -> Int { return player1Sets }
    func getSetsP2() -> Int { return player2Sets }
    
    
    func startNewGame() {
        currentGame = Game()
    }
    
    
    func matchWinner() -> (Bool) {
        if player1Sets == 3 || player2Sets == 3 {
            return true
        }
        return (false)
    }
    
    func getWinner() -> String {
        if player1Sets == 3 {
            return "Player 1"
        } else if player2Sets == 3 {
            return "Player 2"
        } else { return "" }
    }
    
    func endTieBreak() {
        guard let tieBreak = currentSet.tieBreak else { return }
        
        if tieBreak.player1WonTieBreak() {
            player1Sets += 1
        } else if tieBreak.player2WonTieBreak() {
            player2Sets += 1
        }
        currentSet.tieBreak = nil
        startNewSet()
    }
    
    func getPreviousSetsP1() -> [Int] {
        return previousSetsP1
    }
    
    func getPreviousSetsP2() -> [Int] {
        return previousSetsP2
    }
    
    func matchPoint() -> Bool {
        if player1Sets == 3 || player2Sets == 3 { return false }
        else if player1Sets == 2 || player2Sets == 2 {return true}
        else {return false}
    }
    
    func getFinalScore() -> ([Int], [Int]) {
        return (finalScoreP1, finalScoreP2)
    }
    
}
