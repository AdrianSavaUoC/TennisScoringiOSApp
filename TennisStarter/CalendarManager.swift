//
//  CalendarManager.swift
//  TennisStarter
//
//  Created by ADRIAN SAVA on 27/03/2025.
//  Copyright © 2025 University of Chester. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI
import UIKit

class CalendarManager: NSObject, EKEventEditViewDelegate {
    
    var savedFixtures: [FixtureDetails] = []

    let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("fixtures.plist")
    
    private let eventStore = EKEventStore()
    weak var presenter: UIViewController?
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func requestAccessAndAddEvent() {
        
        eventStore.requestAccess(to: .event) { [weak self] success, error in
            guard success, error == nil else { return }
            DispatchQueue.main.async {
                self?.presentEventEditor()
            }
        }
    }
    
    private func presentEventEditor() {
        guard let presenter = presenter else { return }
        
        let newFixture = EKEvent(eventStore: eventStore)
        newFixture.title = "New Fixture"
        newFixture.startDate = Date()
        newFixture.endDate = newFixture.startDate

        
        let fixtureEditVC = EKEventEditViewController()
        fixtureEditVC.eventStore = eventStore
        fixtureEditVC.event = newFixture
        fixtureEditVC.editViewDelegate = self
        
        presenter.present(fixtureEditVC, animated: true, completion: nil)
    }
    
    //get rid of the event editor when the user saves or cancels
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        if action == .saved, let event = controller.event {
            let eventDetails = FixtureDetails(
                title: event.title,
                startDate: event.startDate,
                location: event.location
            )
            
            savedFixtures.append(eventDetails) //store the fixture
            print("Saved event: \(eventDetails)") //debugging
            saveFixture()

            //update the TableView
            DispatchQueue.main.async {
                if let viewController = self.presenter as? ViewController {
                    viewController.tableViewController.reloadData()
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)
}

    //save to plist
    func saveFixture() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(savedFixtures)
            try data.write(to: pathURL!)
        } catch {
            print("Encoding error: \(error)")
        }
        loadFixtures()

    }

    //load from plist
    func loadFixtures() {
        if let pathURL = pathURL {
            let decoder = PropertyListDecoder()
            do {
                let data = try Data(contentsOf: pathURL)
                savedFixtures = try decoder.decode([FixtureDetails].self, from: data)
                savedFixtures.sort { $0.startDate < $1.startDate }
            } catch {
                print("Error loading history: \(error)")
            }
        }
    }
}


extension CalendarManager: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: index)
        var configuration = cell.defaultContentConfiguration()
       
        
        let fixtureTitle = savedFixtures[index.row].title
        
        let fixtureDate = savedFixtures[index.row].startDate
        //format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let formattedDate = dateFormatter.string(from: fixtureDate)
        
        let fixtureLocation = savedFixtures[index.row].location ?? "Not provided"


        configuration.text = "Fixture: \(String(describing: fixtureTitle))\nDate: \(String(describing: formattedDate))\nLocation: \(String(describing: fixtureLocation))"
        
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedFixtures.remove(at: indexPath.row)
            saveFixture()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (savedFixtures.count)
    }
        
    
}
