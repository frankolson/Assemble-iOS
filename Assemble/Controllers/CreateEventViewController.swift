//
//  CreateEventViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/18/21.
//

import UIKit
import Firebase
import CodableFirebase

class CreateEventViewController: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateCell: UITableViewCell!
    @IBOutlet weak var startDatePickerCell: DatePickerTableViewCell!
    @IBOutlet weak var startTimeCell: UITableViewCell!
    @IBOutlet weak var startTimePickerCell: DatePickerTableViewCell!
    @IBOutlet weak var endDateCell: UITableViewCell!
    @IBOutlet weak var endDatePickerCell: DatePickerTableViewCell!
    @IBOutlet weak var endTimeCell: UITableViewCell!
    @IBOutlet weak var endTimePickerCell: DatePickerTableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    
    // MARK: Properties
    
    var user: User!
    var newEvent = NewEvent(title: nil, description: nil, startDate: nil, startTime: nil, endDate: nil, endTime: nil)
    let collapsedPickerCellHeight: CGFloat = 0
    let schdulingTableSection = 1
    var pickerActiveStatuses: [Int:Bool] = [1: false,
                                            3: false,
                                            5: false,
                                            7: false]

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = Auth.auth().currentUser
        
        // Set cancel and save navigation button actions
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        titleTextField.addTarget(self, action: #selector(titleChanged(textField:)), for: .editingChanged)
        configureSchedulingFields()
        setDescriptionLabel(newEvent.description ?? "")
    }
    
    func configureSchedulingFields() {
        startDateCell.detailTextLabel?.text = newEvent.formattedStartDate ?? "Not set"
        startTimeCell.detailTextLabel?.text = newEvent.formattedStartTime ?? "Not set"
        endDateCell.detailTextLabel?.text = newEvent.formattedEndDate ?? "Not set"
        endTimeCell.detailTextLabel?.text = newEvent.formattedEndTime ?? "Not set"
        
        startDatePickerCell.datePicker.addTarget(self, action: #selector(startDateChanged(datePicker:)), for: .valueChanged)
        startTimePickerCell.datePicker.addTarget(self, action: #selector(startTimeChanged(datePicker:)), for: .valueChanged)
        endDatePickerCell.datePicker.addTarget(self, action: #selector(endDateChanged(datePicker:)), for: .valueChanged)
        endTimePickerCell.datePicker.addTarget(self, action: #selector(endTimeChanged(datePicker:)), for: .valueChanged)
    }
    
    // MARK: Actions
    
    @objc func cancel() {
        print("canceled!!")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        createEvent()
        print("saved!!")
        self.dismiss(animated: true, completion: nil)
    }
    
    func createEvent() {
        do {
            let data = try FirebaseEncoder().encode(newEvent)
            
            let reference = Database.database().reference()
            reference.child("events").childByAutoId().setValue(data) { error, databaseReference in
                guard error == nil else {
                    debugPrint(error)
                    return
                }
                
                let newEventUid = databaseReference.key!
                reference.child("userEvents/\(self.user.uid)/\(newEventUid)").setValue(data)
                reference.child("eventOwners/\(newEventUid)/\(self.user.uid)").setValue(true)
            }
        } catch let error {
            debugPrint(error)
        }
    }
    
    @objc func titleChanged(textField: UITextField) {
        validateTitlePresence(textField: textField)
        newEvent.title = textField.text
    }
    
    func validateTitlePresence(textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func startDateChanged(datePicker: UIDatePicker) {
        newEvent.startDate = convertDatetoIsoString(datePicker.date)
        startDateCell.detailTextLabel?.text = newEvent.formattedStartDate ?? "Not set"
    }
    
    @objc func startTimeChanged(datePicker: UIDatePicker) {
        newEvent.startTime = Int(datePicker.date.timeIntervalSince1970)
        startTimeCell.detailTextLabel?.text = newEvent.formattedStartTime ?? "Not set"
    }
    
    @objc func endDateChanged(datePicker: UIDatePicker) {
        newEvent.endDate = convertDatetoIsoString(datePicker.date)
        endDateCell.detailTextLabel?.text = newEvent.formattedEndDate ?? "Not set"
    }
    
    @objc func endTimeChanged(datePicker: UIDatePicker) {
        newEvent.endTime = Int(datePicker.date.timeIntervalSince1970)
        endTimeCell.detailTextLabel?.text = newEvent.formattedEndTime ?? "Not set"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // scheduling
        if indexPath.section == schdulingTableSection && pickerActiveStatuses[indexPath.row] == nil {
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: schdulingTableSection)
            let pickerStatus = pickerActiveStatuses[nextIndexPath.row]
            let pickerCell = tableView.cellForRow(at: nextIndexPath) as! DatePickerTableViewCell
            
            if pickerStatus == false {
                showPickerCell(pickerCell, pickerStatusKey: nextIndexPath.row)
            } else {
                hidePickerCell(pickerCell, pickerStatusKey: nextIndexPath.row)
            }
        }
        
        // description
        if indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: "createEventDecriptionEdit", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.rowHeight
        let pickerActiveStatus = pickerActiveStatuses[indexPath.row]
        
        guard indexPath.section == schdulingTableSection else { return height }
        guard pickerActiveStatus != nil else { return height }

        return pickerActiveStatus! ? height : collapsedPickerCellHeight
    }
    
    func showPickerCell(_ datePickerCell: DatePickerTableViewCell, pickerStatusKey: Int) {
        hideAllOpenPickerCells()
        pickerActiveStatuses[pickerStatusKey] = true
        tableView.beginUpdates()
        tableView.endUpdates()
        
        UIView.animate(withDuration: 0.25) {
            datePickerCell.datePicker.alpha = 1
        } completion: { finished in
            datePickerCell.datePicker.isHidden = false
        }

    }
    
    func hidePickerCell(_ datePickerCell: DatePickerTableViewCell, pickerStatusKey: Int) {
        pickerActiveStatuses[pickerStatusKey] = false
        tableView.beginUpdates()
        tableView.endUpdates()
        
        UIView.animate(withDuration: 0.25) {
            datePickerCell.datePicker.alpha = 0
        } completion: { finished in
            datePickerCell.datePicker.isHidden = true
        }
    }
    
    func hideAllOpenPickerCells() {
        for key in pickerActiveStatuses.keys {
            let indexPath = IndexPath(row: key, section: schdulingTableSection)
            let cell = tableView.cellForRow(at: indexPath) as! DatePickerTableViewCell
            hidePickerCell(cell, pickerStatusKey: key)
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
    
    // MARK: Label Helpers
    
    func setDescriptionLabel(_ description: String) {
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
        setDescriptionLabel(newDescription)
    }
    
    // MARK: Date helpers
    
    func convertDatetoIsoString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }

}
