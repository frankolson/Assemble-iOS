//
//  CreateEventViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/18/21.
//

import UIKit

class CreateEventViewController: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleCell: UITableViewCell!
    @IBOutlet weak var startDateCell: UITableViewCell!
    @IBOutlet weak var startTimeCell: UITableViewCell!
    @IBOutlet weak var endDateCell: UITableViewCell!
    @IBOutlet weak var endTimeCell: UITableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    
    // MARK: Properties
    var newEvent = NewEvent(title: nil, description: nil, startDate: nil, startTime: nil, endDate: nil, endTime: nil)
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set cancel and save navigation button actions
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        
        setDescription(newEvent.description ?? "")
    }
    
    // MARK: Actions
    
    @objc func cancel() {
        print("canceled!!")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        print("saved!!")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // description
        if indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: "createEventDecriptionEdit", sender: self)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "createEventDecriptionEdit" else { return }
        
        if let target = segue.destination as? EditDescriptionViewController {
            target.event = newEvent
            target.descriptionUpdator = updateDescription(_:)
        }
    }
    
    // MARK: Helpers
    
    func setDescription(_ description: String) {
        if description == "" {
            self.descriptionCell.textLabel?.text = "Give info about the event..."
            self.descriptionCell.textLabel?.textColor = .placeholderText
        } else {
            self.descriptionCell.textLabel?.text = description
            self.descriptionCell.textLabel?.textColor = .label
        }
    }
    
    func updateDescription(_ newDescription: String) {
        newEvent.description = newDescription
        setDescription(newDescription)
    }

}
