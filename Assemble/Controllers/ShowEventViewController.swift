//
//  ShowEventViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/30/21.
//

import UIKit

class ShowEventViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var guestListTableView: UITableView!
    
    // MARK: Properties
    
    var event: Event!
    var guestList: [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        guestListTableView.delegate = self
        guestListTableView.dataSource = self

        titleLabel.text = event.title
        scheduleLabel.text = event.formattedStartDate // change to full schedule
        descriptionLabel.text = event.description
        loadGuestList()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareEvent", let target = segue.destination as? ShareEventViewController {
            target.event = event
        }
        
        return
    }
    
    // MARK: - Actions
    
    @IBAction func share(_ sender: Any) {
        performSegue(withIdentifier: "shareEvent", sender: self)
    }
    
    // MARK: - Helpers
    
    func loadGuestList() {
        FirebaseService().getEventGuestList(event.uid) { people, error in
            if let error = error {
                debugPrint(error)
                return
            }
            
            self.guestList = people
            self.guestListTableView.reloadData()
        }
    }
    
}

extension ShowEventViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue cell
        let cell: UITableViewCell = guestListTableView.dequeueReusableCell(withIdentifier: "guestCell", for: indexPath)
        let guest: Person! = guestList[indexPath.row]
        
        cell.textLabel?.text = guest.email ?? "Anonymous"
        
        return cell
    }
    
    
}
