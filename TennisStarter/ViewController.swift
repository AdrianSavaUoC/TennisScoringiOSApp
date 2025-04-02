import UIKit
import Foundation
import EventKit
import EventKitUI
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate {

    
    @IBOutlet weak var tableViewController: UITableView!
    var calendarManager: CalendarManager?
    private let countryManager = CountryManager()

    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var p1Button: UIButton!
    @IBOutlet weak var p2Button: UIButton!
    @IBOutlet weak var p1NameLabel: UILabel!
    @IBOutlet weak var p2NameLabel: UILabel!
    @IBOutlet weak var p1PointsLabel: UILabel!
    @IBOutlet weak var p2PointsLabel: UILabel!
    @IBOutlet weak var p1GamesLabel: UILabel!
    @IBOutlet weak var p2GamesLabel: UILabel!
    @IBOutlet weak var p1SetsLabel: UILabel!
    @IBOutlet weak var p2SetsLabel: UILabel!
    @IBOutlet weak var p1PreviousSetsLabel: UILabel!
    @IBOutlet weak var p2PreviousSetsLabel: UILabel!

    var match = Match()
    private var tieBreak : TieBreak?
    var inTieBreak = false
    
    private var audioPlayer: AVAudioPlayer?
    private var currentServer: Int? // Store the current server (initially nil)
    
    var extScr: ExtScrViewController?
    
    
    var finalScore = ([], [])
    

    @IBAction func historyPressed(_ sender: Any) {
        
        if let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController {
            storyboard.finalScore = self.finalScore
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
        finalScore = ([], [])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        p1NameLabel.backgroundColor = .purple
        p1NameLabel.textColor = .white
        currentServer = match.currentSet.getCurrentServer()
        setUpExternalScreen()

        setupSound()
        setupCalendar()
        setupCountryManager()
    }

    @IBAction func p1AddPointPressed(_ sender: UIButton) {

        if inTieBreak, let tieBreak = tieBreak {
            tieBreak.addPointToPlayer1()
            match.currentSet.switchServerTieBreak()
            updateTieBreakScoreLabels()
            updateServerHighlight()

            if tieBreak.player1WonTieBreak() {
                match.addSetToPlayer1()
                endTieBreak()
            }
        } else {
            match.addPointToPlayer1()
            updateGameAndSetStatus()
            updateLabels()
        }

        checkMatchOver()
        updateServerHighlight()
    }

    @IBAction func p2AddPointPressed(_ sender: UIButton) {
        if inTieBreak, let tieBreak = tieBreak {
            tieBreak.addPointToPlayer2()
            match.currentSet.switchServerTieBreak()
            updateTieBreakScoreLabels()
            updateServerHighlight()
            if tieBreak.player2WonTieBreak() {
                match.addSetToPlayer2()
                endTieBreak()
            }
        } else {
            match.addPointToPlayer2()
            updateGameAndSetStatus()
            updateLabels()
        }

        checkMatchOver()
        updateServerHighlight()
    }
    
    private func endTieBreak() {
        inTieBreak = false
        tieBreak = nil
        match.currentSet.tieBreak = nil
        match.startNewSet()
        updateLabels()
    }

    private func updateGameAndSetStatus() {
        if match.currentSet.checkForTieBreak() && !inTieBreak {
            inTieBreak = true
            tieBreak = TieBreak()
            match.currentSet.tieBreak = tieBreak
            p1PointsLabel.backgroundColor = .clear
            p2PointsLabel.backgroundColor = .clear
            match.currentGame = nil
            updateLabels()
        } else if match.currentGame?.player1Won() == true || match.currentGame?.player2Won() == true {
            match.startNewGame()
        }

        if match.currentSet.complete() {
            endTieBreak()
        }
    }

    @IBAction func restartPressed(_ sender: AnyObject) {
        match = Match()
        inTieBreak = false
        updateLabels()
        p1Button.isEnabled = true
        p2Button.isEnabled = true
        p1NameLabel.backgroundColor = .purple
        p1NameLabel.textColor = .white
        p2NameLabel.backgroundColor = .clear
        p2NameLabel.textColor = .black
        
        extScr?.clearSecondScreen()
        
        countryLabel.text = "Location not yet set"
    }

    private func updateLabels() {
        if inTieBreak {
            updateTieBreakScoreLabels()
        } else if let currentGame = match.currentGame {
            p1PointsLabel.text = "\(currentGame.player1Score())"
            p2PointsLabel.text = "\(currentGame.player2Score())"
            if match.currentGame!.gamePointsForPlayer1() > 0 {
                p1PointsLabel.backgroundColor = .green
            } else if match.currentGame!.gamePointsForPlayer2() > 0 {
                p2PointsLabel.backgroundColor = .green
            } else {
                p1PointsLabel.backgroundColor = .clear
                p2PointsLabel.backgroundColor = .clear
            }
        } else {
            p1PointsLabel.text = "0"
            p2PointsLabel.text = "0"
        }
        
        p1GamesLabel.text = "\(match.currentSet.getGamesP1())"
        p2GamesLabel.text = "\(match.currentSet.getGamesP2())"
        
        p1SetsLabel.text = "\(match.getSetsP1())"
        p2SetsLabel.text = "\(match.getSetsP2())"
        
        highlightPlayers()
        
        p1PreviousSetsLabel.text = match.getPreviousSetsP1().map { "\($0)" }.joined(separator: "-")
        p2PreviousSetsLabel.text = match.getPreviousSetsP2().map { "\($0)" }.joined(separator: "-")
        
        extScr?.updateLabels()
    }
    
    func highlightPlayers() {
        if match.currentSet.setPointForPlayer1() && (match.currentGame?.gamePointsForPlayer1())! > 0 {
            p1GamesLabel.backgroundColor = .green
        } else if match.currentSet.setPointForPlayer2() && (match.currentGame?.gamePointsForPlayer2())! > 0 {
            p2GamesLabel.backgroundColor = .green
        } else {
            p1GamesLabel.backgroundColor = .clear
            p2GamesLabel.backgroundColor = .clear
        }
        
        if match.matchPoint() && match.currentSet.setPointForPlayer1() && (match.currentGame?.gamePointsForPlayer1())! > 0 {
            p1SetsLabel.backgroundColor = .green
        } else if match.matchPoint() && match.currentSet.setPointForPlayer2() && (match.currentGame?.gamePointsForPlayer2())! > 0 {
            p2SetsLabel.backgroundColor = .green
        } else {
            p1SetsLabel.backgroundColor = .clear
            p2SetsLabel.backgroundColor = .clear
        }
    }

    private func updateTieBreakScoreLabels() {
        if tieBreak!.gamePointForPlayer1() {
            p1PointsLabel.backgroundColor = .green
            p1GamesLabel.backgroundColor = .green
        } else if tieBreak!.gamePointForPlayer2() {
            p2PointsLabel.backgroundColor = .green
            p2GamesLabel.backgroundColor = .green
        } else {
            p1PointsLabel.backgroundColor = .clear
            p2PointsLabel.backgroundColor = .clear
            p1GamesLabel.backgroundColor = .clear
            p2GamesLabel.backgroundColor = .clear
        }
        
        p1PointsLabel.text = "\(tieBreak!.getPointsPlayer1())"
        p2PointsLabel.text = "\(tieBreak!.getPointsPlayer2())"
    }

    func checkMatchOver() {
        if match.matchWinner() {
            p1Button.isEnabled = false
            p2Button.isEnabled = false
            
            let alertTitle = "Match Over!"
            let alertMessage = "\(match.getWinner()) wins the match!\nFuture match at:\n \(calendarManager?.savedFixtures[0].location ?? "No future fixtures just yet")"
            
            finalScore = match.getFinalScore()
            
            print (finalScore.0)
            
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func updateServerHighlight() {
        let newServer = match.currentSet.getCurrentServer()
        if newServer != currentServer {
            if audioPlayer != nil {
                audioPlayer?.play()
            }
        }
        
        currentServer = newServer
        if newServer == 1 {
            p1NameLabel.backgroundColor = .purple
            p2NameLabel.backgroundColor = .clear
            p1NameLabel.textColor = .white
            p2NameLabel.textColor = .black
        } else {
            p1NameLabel.backgroundColor = .clear
            p2NameLabel.backgroundColor = .purple
            p2NameLabel.textColor = .white
            p1NameLabel.textColor = .black
        }
    }
    
}


extension ViewController: EKEventViewDelegate {
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
    
    }
    
    //func to call add new calendar event, through our CalendarManager class
    @objc func addPressed() {
        calendarManager?.requestAccessAndAddEvent()
    }
    
    //show future fixtures
    @objc func showSavedEvents() {
        if let events = calendarManager?.savedFixtures {
            for event in events {
                print("Title: \(event.title), Date: \(event.startDate), Location: \(event.location ?? "No location")")
            }
        }
    }
    
    private func setupCalendar() {
        //make a calendar and add the add to calendar button
        calendarManager = CalendarManager(presenter: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        tableViewController.delegate = self
        tableViewController.dataSource = calendarManager
        calendarManager?.loadFixtures()
    }
}

extension ViewController {
    
    private func setUpExternalScreen() {
        extScr = ExtScrViewController()
        extScr?.firstScreen = self
        extScr?.match = self.match
        extScr?.tieBreak = self.tieBreak
        NotificationCenter.default.addObserver(extScr!, selector: #selector(extScr?.handleAdditionalScreen), name: UIScene.willConnectNotification, object: nil)
        NotificationCenter.default.addObserver(extScr!, selector: #selector(extScr?.handleScreenDisconnect), name: UIScene.didDisconnectNotification, object: nil)
    }
    
    //setup sound
    private func setupSound() {
        guard let soundURL = Bundle.main.url(forResource: "Sound", withExtension: "wav") else {
            print("Could not find Sound.wav")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = 0
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
    
    //deal with the location manager
    private func setupCountryManager() {
        countryManager.requestLocationPermission()
        countryManager.onCountryReceived = { [weak self] country in
            DispatchQueue.main.async {
                self?.countryLabel.text = "Location not yet set"
            }
        }
    }
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        countryManager.fetchCountry()
        countryManager.onCountryReceived = { [weak self] country in
            DispatchQueue.main.async {
                self?.countryLabel.text = country
            }
        }
    }
    
}
