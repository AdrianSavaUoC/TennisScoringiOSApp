//
//  HistoryViewController.swift
//  TennisStarter
//
//  Created by ADRIAN SAVA on 17/03/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    
    @IBOutlet weak var tableViewHistory: UITableView!
    
    var finalScore: ([Any], [Any]) = ([], [])
    
    let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("matchHistory.plist")
    
    var scores_list = [MatchesHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(pathURL!)
        
        print(finalScore.1)
        loadHistory()
        addToHist()
        saveHistory()
        show()
        
        tableViewHistory.delegate = self
        tableViewHistory.dataSource = self
    }
    
    
    func addToHist() {
        if !finalScore.0.isEmpty && !finalScore.1.isEmpty {
            let newMatch = MatchesHistory()
            newMatch.scores[0] = finalScore.0.compactMap { $0 as? Int }
            newMatch.scores[1] = finalScore.1.compactMap { $0 as? Int }
            scores_list.insert(newMatch, at: 0)
        }
    }
    
    
    func saveHistory() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(scores_list)
            try data.write(to: pathURL!)
        } catch {
            print("Encoding error: \(error)")
        }
    }
    
        
    func show() {
        for (index, match) in scores_list.enumerated() {
            print("Match \(index + 1): \(match.scores)")
        }
    }
    
    
    func loadHistory() {
        if let pathURL = pathURL {
            let decoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                scores_list = try decoder.decode([MatchesHistory].self, from: data)
            } catch {
                print("Error loading history: \(error)")
            }
        }
    }
    
}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellP1", for: index)
        var configuration = cell.defaultContentConfiguration()
        
        let match = scores_list[index.row]
        let scoresP1 = match.scores[0].map { "\($0)" }.joined(separator: " - ")
        let scoresP2 = match.scores[1].map { "\($0)" }.joined(separator: " - ")
        
        configuration.text = "Match \(index.row + 1)\nPlayer 1:    \(scoresP1)\nPlayer 2:    \(scoresP2)"
        
        cell.contentConfiguration = configuration
        return cell
    }



    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores_list.count
    }
}
