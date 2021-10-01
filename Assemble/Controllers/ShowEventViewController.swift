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
    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var yesRsvpButton: UIButton!
    @IBOutlet weak var noRsvpButton: UIButton!
    @IBOutlet weak var invitedRsvpButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    
    // MARK: Properties
    
    var event: Event!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = event.title
        scheduleLabel.text = event.formattedStartDate // change to full schedule
        descriptionLabel.text = event.description
        // TODO: create method for fetching RSVPs
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
