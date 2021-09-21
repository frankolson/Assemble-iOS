//
//  EditDescriptionViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/18/21.
//

import UIKit

class EditDescriptionViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // MARK: Properties
    
    var event: NewEvent!
    var descriptionUpdator: ((_ description: String) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descriptionTextField.delegate = self
        descriptionTextField.text = event.description
        descriptionTextField.becomeFirstResponder()
    }

}

// MARK: - UITextViewDelegate

extension EditDescriptionViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        event.description = descriptionTextField.text
        descriptionUpdator(event.description ?? "")
    }
    
}
