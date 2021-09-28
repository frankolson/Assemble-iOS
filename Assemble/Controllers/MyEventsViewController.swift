//
//  MyEventsViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/17/21.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase

class MyEventsViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var myEventsTable: UITableView!
    @IBOutlet weak var newEventButton: UIButton!
    
    // MARK: Properties
    
    var ref: DatabaseReference!
    var user: User!
    var myEvents: [Event] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myEventsTable.delegate = self
        myEventsTable.dataSource = self
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        refreshEvents()
    }
    
    func refreshEvents() {
        ref.child("userEvents").child(user.uid).getData(completion: { error, snapshot in
            guard error == nil else {
                debugPrint(error!)
                return
            }
            guard snapshot.value != nil else { return }

            self.myEvents = snapshot.children.compactMap { singleEventSnapshot -> Event? in
                do {
                    let singleEventSnapshot = singleEventSnapshot as! DataSnapshot
                    let event = try FirebaseDecoder().decode(Event.self, from: singleEventSnapshot.value!)
                    return event
                } catch let error {
                    print(error)
                }
                
                return nil
            }
            
            self.myEventsTable.reloadData()
        })
    }
    
    // MARK: Actions
    
    @IBAction func presentCreateNewEvent(_ sender: Any) {
        performSegue(withIdentifier: "createEvent", sender: nil)
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
