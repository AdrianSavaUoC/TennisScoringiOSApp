import UIKit

class Game {
    
    
    private var p1Points = 0
    private var p2Points = 0
      
    /**
     This method will be called when player 1 wins a point and update the state of the instance of Game to reflect the change
     */
    func addPointToPlayer1() {
        p1Points += 1
    }
    
    
    /**
     Returns Player 1 points in the current game
     */
    func getPointsPlayer1() -> Int { return p1Points }
    
    
    /**
     This method will be called when player 2 wins a point
     */
    func addPointToPlayer2(){
        p2Points += 1
    }
    
    func getPointsPlayer2() -> Int { return p2Points }
    
    
    /**
     Returns the score for player 1, this will only ever be "0","15","30","40" or "A"
     If the game is complete, this should return an empty string
     */
    func player1Score() -> String {
        if p1Points >= 4 && p1Points == p2Points { return "40" } // Deuce
        if p1Points >= 4 && p1Points == p2Points + 1 { return "A" } // Advantage
        if p1Points >= 4 && p2Points >= 4 && p2Points == p1Points + 1 { return "40" } // Return to Deuce
        if player1Won() { return "" } // Win condition

        let scores = ["0", "15", "30", "40"]
        return p1Points < scores.count ? scores[p1Points] : ""
    }
        

    /**
     Returns the score for player 2, this will only ever be "0","15","30","40" or "A"
     If the game is complete, this should return an empty string
     */
    func player2Score() -> String {
        if p2Points >= 4 && p2Points == p1Points { return "40" }
        if p2Points >= 4 && p2Points == p1Points + 1 { return "A" }
        if p2Points >= 4 && p1Points >= 4 && p1Points == p2Points + 1 { return "40" }
        if player2Won() { return "" }

        let scores = ["0", "15", "30", "40"]
        return p2Points < scores.count ? scores[p2Points] : ""
    }
    /**
     Returns true if player 1 has won the game, false otherwise
     */
    func player1Won() -> Bool {
        return p1Points >= 4 && p1Points >= p2Points + 2
    }

    
    /**
     Returns true if player 2 has won the game, false otherwise
     */
    func player2Won() -> Bool {
        return p2Points >= 4 && p2Points >= p1Points + 2
    }
    
    /**
     Returns true if the game is finished, false otherwise
     */
    func complete() -> Bool {
        return player1Won() || player2Won()
    }
    
    /**
     If player 1 would win the game if they won the next point, returns the number of points player 2 would need to win to equalise the score, otherwise returns 0
     e.g. if the score is 40:15 to player 1, player 1 would win if they scored the next point, and player 2 would need 2 points in a row to prevent that, so this method should return 2 in that case.
     */
    func gamePointsForPlayer1() -> Int {

        if player1Won() || player2Won() { return 0 } // Game is already won
        if p1Points >= 3  && (p1Points - p2Points) > 0 {return p1Points - p2Points}
        return 0
        
    }
    
    /**
     If player 2 would win the game if they won the next point, returns the number of points player 1 would need to win to equalise the score
     */
    func gamePointsForPlayer2() -> Int {

        if player2Won() || player1Won() { return 0 } // Game is already won
        if p2Points >= 3  && (p2Points - p1Points) > 0 {return p2Points - p1Points}
        return 0
        
    }
    
}
