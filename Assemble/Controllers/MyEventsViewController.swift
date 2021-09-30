//
//  MyEventsViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/17/21.
//

import UIKit

class MyEventsViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var myEventsTable: UITableView!
    @IBOutlet weak var newEventButton: UIButton!
    
    // MARK: Properties
    
    var firebaseClient = FirebaseService()
    var myEvents: [Event] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myEventsTable.delegate = self
        myEventsTable.dataSource = self
        refreshEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshEvents()
    }
    
    func refreshEvents() {
        firebaseClient.getMyEvents() { events, error in
            guard error == nil else {
                debugPrint(error!)
                return
            }
            
            self.myEvents = events
            self.myEventsTable.reloadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction func presentCreateNewEvent(_ sender: Any) {
        performSegue(withIdentifier: "createEvent", sender: nil)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "createEvent" else { return }
        
        if let target = segue.destination as? UINavigationController,
           let root = target.viewControllers[0] as? CreateEventViewController {
            root.completionSelector = { () in
                self.refreshEvents()
            }
        }
    }
    
}

// MARK: Table View Delegate

extension MyEventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue cell
        let cell: UITableViewCell = myEventsTable.dequeueReusableCell(withIdentifier: "myEventCell", for: indexPath)
        let myEvent: Event! = myEvents[indexPath.row]
        
        cell.textLabel?.text = myEvent.title
        cell.detailTextLabel?.text = myEvent.formattedStartDate
        
        return cell
    }
    
}
