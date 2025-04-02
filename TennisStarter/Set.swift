//
//   Set.swift
//   TennisStarter
//
//   Created by ADRIAN SAVA on 09/02/2025.
//   Copyright © 2025 University of Chester. All rights reserved.
//

import UIKit

class Set {
    private var p1Games = 0
    private var p2Games = 0
    var tieBreak: TieBreak?
    var currentServer: Int = 1
       
    
    init(startingServer: Int = 1) {
        currentServer = startingServer
    }

    func addGameToPlayer1() {
        guard tieBreak == nil else { return }
        p1Games += 1
        if checkForTieBreak() {
            tieBreak = TieBreak()
        }
        switchServer()
    }

    func addGameToPlayer2() {
        guard tieBreak == nil else { return }
        p2Games += 1
        if checkForTieBreak() {
            tieBreak = TieBreak()
        }
        switchServer()
    }

    func addTieBreakWin() {
        resetGames()
        tieBreak = nil
        switchServer() 
    }

    func checkForTieBreak() -> Bool {
        if p1Games == 6 && p2Games == 6 {
            return true
        }
        return false
    }

    func checkForSetWin() -> (Bool, Int) {
        if p1Games >= 6 && (p1Games - p2Games) >= 2 {
            return (true, 1)
        } else if p2Games >= 6 && (p2Games - p1Games) >= 2 {
            return (true, 2)
        }
        return (false, 0)
    }

    func resetGames() {
        p1Games = 0
        p2Games = 0
    }

    func addPointToPlayer1() {
        if let tieBreak = tieBreak {
            tieBreak.addPointToPlayer1()
            if tieBreak.player1WonTieBreak() {
                addTieBreakWin()
            }
        }
    }

    func addPointToPlayer2() {
        if let tieBreak = tieBreak {
            tieBreak.addPointToPlayer2()
            if tieBreak.player2WonTieBreak() {
                addTieBreakWin()
            }
        }
    }    


    func getGamesP1() -> Int { return p1Games }
    func getGamesP2() -> Int { return p2Games }

    func player1WonSet() -> Bool {
        let (won, winner) = checkForSetWin()
        return won && winner == 1
    }

    func player2WonSet() -> Bool {
        let (won, winner) = checkForSetWin()
        return won && winner == 2
    }
    
    
    func setPointForPlayer1() -> Bool {
        if player1WonSet() || player2WonSet() { return false }

        if p1Games >= 5 && (p1Games - p2Games) >= 1 {
            return true
        }
        
        return false
    }
    
    func setPointForPlayer2() -> Bool {
        if player1WonSet() || player2WonSet() { return false }

        if p2Games >= 5 && (p2Games - p1Games) >= 1 {
            return true
        }
        
        return false
    }

    
    

    func complete() -> Bool {
        return player1WonSet() || player2WonSet()
    }
    
    
    private func switchServer() {
        currentServer = (currentServer == 1) ? 2 : 1
    }
    
    func switchServerTieBreak() {
         guard let tieBreak = tieBreak else { return }

        if tieBreak.pointsPlayed == 0 {
        } else if tieBreak.pointsPlayed == 1 {
            currentServer = (currentServer == 1) ? 2 : 1
        } else if (tieBreak.pointsPlayed - 1) % 2 == 0 {
            currentServer = (currentServer == 1) ? 2 : 1
        }
     }

    func getCurrentServer() -> Int {
        return currentServer
    }
    
    
}

