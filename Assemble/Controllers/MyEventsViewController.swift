//
//  MyEventsViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/17/21.
//

import UIKit
import FirebaseAuth

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
        handleDeepLinks()
        refreshEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
        
        handleDeepLinks()
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
    
    func handleDeepLinks() {
        print("Processing potential deeplinks")
        guard let deeplink = DynamicLinksProcessing.shared.deepLink else { return }
        print("found deeplink: \(deeplink)")
        
        switch deeplink {
        case .home:
            break
        case .addToGuestList(let eventUid, let inviteCode):
            firebaseClient.getEvent(eventUid) { event, error in
                if let error = error {
                    debugPrint(error)
                    return
                }
                guard let event = event else { return }
                print("found event: \(event.title)")
                
                self.firebaseClient.addUserToGuestList(Auth.auth().currentUser!, event: event, inviteCode: inviteCode) { error in
                    if let error = error {
                        debugPrint(error)
                        return
                    }
                    
                    DynamicLinksProcessing.shared.deepLink = nil
                    print("Guest list updated and deeplink cleared")
                    self.performSegue(withIdentifier: "showEvent", sender: event)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "createEvent" || segue.identifier == "showEvent" else { return }
        
        if let target = segue.destination as? UINavigationController,
           let root = target.viewControllers[0] as? CreateEventViewController {
            root.completionSelector = { () in
                self.refreshEvents()
            }
        }
        
        if let target = segue.destination as? ShowEventViewController {
            target.event = (sender as! Event)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = myEvents[indexPath.row]
        performSegue(withIdentifier: "showEvent", sender: event)
    }
    
}
