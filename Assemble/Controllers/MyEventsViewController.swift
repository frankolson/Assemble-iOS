//
//  MyEventsViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/17/21.
//

import UIKit
import Firebase
import FirebaseAuth

class MyEventsViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var myEventsTable: UITableView!
    @IBOutlet weak var newEventButton: UIButton!
    
    // MARK: Properties
    
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle!
    var user: User!
    var myEvents: [DataSnapshot] = []
    
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
            guard error == nil else { return }
            
            if let userEvents = snapshot.value as? [String:Bool] {
                for uid in userEvents.keys {
                    self.ref.child("events").child(uid).getData { error, snapshot in
                        guard error == nil else { return }
                        
                        self.myEvents.append(snapshot)
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
        let myEventSnapshot: DataSnapshot! = myEvents[indexPath.row]
        let myEvent = myEventSnapshot.value as! [String:String]
        
        let title = myEvent[Constants.EventFields.title]
        cell.textLabel?.text = title
        
        if let startDateString = myEvent[Constants.EventFields.startDate] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            
            if let startDate = dateFormatter.date(from: startDateString) {
                cell.detailTextLabel?.text = dateFormatter.string(from: startDate)
            }
        }
        
        return cell
    }
    
}
