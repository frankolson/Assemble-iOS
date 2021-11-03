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

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = event.title
        scheduleLabel.text = event.formattedStartDate // change to full schedule
        descriptionLabel.text = event.description
        // TODO: create method for fetching RSVPs
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
    
}
