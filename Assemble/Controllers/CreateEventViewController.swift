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
    
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set cancel and save navigation button actions
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
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
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.reuseIdentifier == "eventDescriptionCell" {
            performSegue(withIdentifier: "createEventDecriptionEdit", sender: cell)
        }
    }

}
