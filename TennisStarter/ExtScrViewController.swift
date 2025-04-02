//
//  ExtScrViewController.swift
//  TennisStarter
//
//  Created by ADRIAN SAVA on 16/02/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

import UIKit
import AVFoundation

class ExtScrViewController: UIViewController {
    
    private var scoreTitle = UILabel(frame: CGRect(x: 50, y: 50, width: 800, height: 100))
    private var p1Label = UILabel(frame: CGRect(x: 50, y: 350, width: 200, height: 100))
    private var p2Label = UILabel(frame: CGRect(x: 50, y: 450, width: 200, height: 100))
    
    private var p1PreviousSetsFixLabel = UILabel(frame: CGRect(x: 350, y: 250, width: 250, height: 100))
    private var setsFixLabel = UILabel(frame: CGRect(x: 650, y: 250, width: 110, height: 100))
    private var gamesFixLabel = UILabel(frame: CGRect(x: 800, y: 250, width: 180, height: 100))
    private var pointsFixLabel = UILabel(frame: CGRect(x: 1010, y: 250, width: 180, height: 100))

    private var p1PreviousSetsabel = UILabel(frame: CGRect(x: 350, y: 350, width: 270, height: 100))
    private var p2PreviousSetsLabel = UILabel(frame: CGRect(x: 350, y: 450, width: 270, height: 100))
    private var p1SetsLabel = UILabel(frame: CGRect(x: 650, y: 350, width: 80, height: 100))
    private var p2SetsLabel = UILabel(frame: CGRect(x: 650, y: 450, width: 80, height: 100))
    private var p1GamesLabel = UILabel(frame: CGRect(x: 800, y: 350, width: 80, height: 100))
    private var p2GamesLabel = UILabel(frame: CGRect(x: 800, y: 450, width: 80, height: 100))
    private var p1PointsLabel = UILabel(frame: CGRect(x: 1010, y: 350, width: 80, height: 100))
    private var p2PointsLabel = UILabel(frame: CGRect(x: 1010, y: 450, width: 80, height: 100))

    private var secondWindow: UIWindow?
    private var secondWindowView: UIView?
    private var secondLabel: UILabel?
    
    var firstScreen = ViewController()
    var match: Match?
    var tieBreak: TieBreak?
    
 
    
    
    @objc func handleAdditionalScreen(notification: NSNotification) {
        
        guard let windowScene = (notification.object as? UIWindowScene)
        else {return}
        
        guard windowScene.session.role == .windowExternalDisplayNonInteractive else {return}
        secondWindow = UIWindow(windowScene: windowScene)
        let viewController = UIViewController()
        
        secondWindow!.rootViewController = viewController
        secondWindowView = UIView(frame: secondWindow!.frame)
        secondWindow!.addSubview(secondWindowView!)
        
        secondWindow!.isHidden = false
        secondWindow!.backgroundColor = .white
        setUpLabels()
        updateLabels()
    }
    
    func stylise(label: UILabel!) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .black
    }
    
    func setUpLabels () {
        
        secondWindowView!.addSubview(scoreTitle)
        scoreTitle.text = "--- Score Table ---"
        secondLabel = scoreTitle
        stylise(label: scoreTitle)
        
        secondWindowView!.addSubview(p1Label)
        secondLabel = p1Label
        stylise(label: p1Label)
        p1Label.text = "Player 1:"
        
        secondWindowView!.addSubview(p2Label)
        secondLabel = p2Label
        stylise(label: p2Label)
        p2Label.text = "Player 2:"
        
        secondWindowView!.addSubview(p1PreviousSetsFixLabel)
        secondLabel = p1PreviousSetsFixLabel
        stylise(label: p1PreviousSetsFixLabel)
        p1PreviousSetsFixLabel.text = "Set Scores"
        
        secondWindowView!.addSubview(setsFixLabel)
        secondLabel = setsFixLabel
        stylise(label: setsFixLabel)
        setsFixLabel.text = "Sets"
        
        secondWindowView!.addSubview(gamesFixLabel)
        secondLabel = gamesFixLabel
        stylise(label: gamesFixLabel)
        gamesFixLabel.text = "Games"
        
        secondWindowView!.addSubview(pointsFixLabel)
        secondLabel = pointsFixLabel
        stylise(label: pointsFixLabel)
        pointsFixLabel.text = "Points"
        
        secondWindowView!.addSubview(p1PreviousSetsabel)
        secondLabel = p1PreviousSetsabel
        p1PreviousSetsabel.font = UIFont.italicSystemFont(ofSize: 50)
        
        secondWindowView!.addSubview(p2PreviousSetsLabel)
        secondLabel = p2PreviousSetsLabel
        p2PreviousSetsLabel.font = UIFont.italicSystemFont(ofSize: 50)
        
        secondWindowView!.addSubview(p1SetsLabel)
        secondLabel = p1SetsLabel
        p1SetsLabel.font = UIFont.italicSystemFont(ofSize: 50)
        
        secondWindowView!.addSubview(p2SetsLabel)
        secondLabel = p2SetsLabel
        p2SetsLabel.font = UIFont.italicSystemFont(ofSize: 50)
        
        secondWindowView!.addSubview(p1GamesLabel)
        secondLabel = p1GamesLabel
        p1GamesLabel.font = UIFont.italicSystemFont(ofSize: 50)
        
        secondWindowView!.addSubview(p2GamesLabel)
        secondLabel = p2GamesLabel
        p2GamesLabel.font = UIFont.italicSystemFont(ofSize: 50)
        
        secondWindowView!.addSubview(p1PointsLabel)
        secondLabel = p1PointsLabel
        p1PointsLabel.font = UIFont.italicSystemFont(ofSize: 50)
        
        secondWindowView!.addSubview(p2PointsLabel)
        secondLabel = p2PointsLabel
        p2PointsLabel.font = UIFont.italicSystemFont(ofSize: 50)

    }
    
    func updateLabels() {
        guard let currentMatch = match else { return }

        if let tieBreak = currentMatch.currentSet.tieBreak, firstScreen.inTieBreak == true {
            p1PointsLabel.text = "\(tieBreak.getPointsPlayer1())"
            p2PointsLabel.text = "\(tieBreak.getPointsPlayer2())"

        } else if let currentGame = currentMatch.currentGame {
            p1PointsLabel.text = "\(currentGame.player1Score())"
            p2PointsLabel.text = "\(currentGame.player2Score())"

            if currentGame.gamePointsForPlayer1() > 0 {
                p1PointsLabel.backgroundColor = .green
            } else if currentGame.gamePointsForPlayer2() > 0 {
                p2PointsLabel.backgroundColor = .green
            } else {
                p1PointsLabel.backgroundColor = .clear
                p2PointsLabel.backgroundColor = .clear
            }
        } else {
            p1PointsLabel.text = "0"
            p2PointsLabel.text = "0"
            p1PointsLabel.backgroundColor = .clear
            p2PointsLabel.backgroundColor = .clear
        }

        p1GamesLabel.text = String(currentMatch.currentSet.getGamesP1())
        p2GamesLabel.text = String(currentMatch.currentSet.getGamesP2())
        p1SetsLabel.text = String(currentMatch.getSetsP1())
        p2SetsLabel.text = String(currentMatch.getSetsP2())
        p1PreviousSetsabel.text = currentMatch.getPreviousSetsP1().map { "\($0)" }.joined(separator: "-")
        p2PreviousSetsLabel.text = currentMatch.getPreviousSetsP2().map { "\($0)" }.joined(separator: "-")
    }
    
    func clearSecondScreen() {
        p1PointsLabel.backgroundColor = .clear
        p2PointsLabel.backgroundColor = .clear

        self.match = firstScreen.match
        self.tieBreak = firstScreen.match.currentSet.tieBreak
        updateLabels()
    }
    
    @objc func handleScreenDisconnect(notification: NSNotification) {
        secondWindow = nil
        secondWindowView = nil
    }
}
