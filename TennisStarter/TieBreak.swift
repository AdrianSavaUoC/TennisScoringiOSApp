//
//  TieBreak.swift
//  TennisStarter
//
//  Created by ADRIAN SAVA on 09/02/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//


class TieBreak {
    private var p1Points = 0
    private var p2Points = 0
    var pointsPlayed = 0
    
    func addPointToPlayer1() {
        p1Points += 1
        pointsPlayed += 1

    }
    
    func addPointToPlayer2() {
        p2Points += 1
        pointsPlayed += 1

    }
    
    func getPointsPlayer1() -> Int {return p1Points}
    func getPointsPlayer2() -> Int  {return p2Points}
    
    
    func player1WonTieBreak() -> Bool {
        return p1Points >= 7 && (p1Points - p2Points) >= 2
    }
    
    func player2WonTieBreak() -> Bool {
        return p2Points >= 7 && (p2Points - p1Points) >= 2
    }
    
    func gamePointForPlayer1() -> Bool {
        if player1WonTieBreak() || player2WonTieBreak() { return false }
        else if getPointsPlayer1() >= 6 && (getPointsPlayer1() - getPointsPlayer2()) >= 1 {
            return true
        } else {
            return false
        }
    }

    func gamePointForPlayer2() -> Bool {
        if player1WonTieBreak() || player2WonTieBreak() { return false }
        else if getPointsPlayer2() >= 6 && (getPointsPlayer2() - getPointsPlayer1()) >= 1 {
            return true
        } else {
            return false
        }
    }

    
    
    
    
    func complete() -> Bool {
        return player1WonTieBreak() || player2WonTieBreak()
    }
}
