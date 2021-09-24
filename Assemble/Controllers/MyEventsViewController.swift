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
    fileprivate var _refHandle: DatabaseHandle!
    var user: User!
    var myEvents: [Event] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = Auth.auth().currentUser
        ref = Database.database().reference()
        refreshEvents()
    }
    
    func refreshEvents() {
        myEvents = []
        
        ref.child("userEvents").child(user.uid).getData(completion: { error, snapshot in
            guard let userEvents = snapshot.value as? [String:Bool] else { return }
            
            for uid in userEvents.keys {
                self.ref.child("events").child(uid).getData { error, snapshot in
                    guard let value = snapshot.value else { return }
                    
                    do {
                        let event = try FirebaseDecoder().decode(Event.self, from: value)
                        self.myEvents.append(event)
                    } catch let error {
                        debugPrint(error)
                    }
                }
            }
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
//        let myEvent = myEventSnapshot.value as! [String:String]
        
        cell.textLabel?.text = myEvent.title
        cell.detailTextLabel?.text = myEvent.formattedStartDate
        
        return cell
    }
    
}
