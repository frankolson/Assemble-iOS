//
//  EditDescriptionViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/18/21.
//

import UIKit

class EditDescriptionViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: Properties
    
    var event: NewEvent!
    var descriptionUpdator: ((_ description: String) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descriptionTextView.delegate = self
        descriptionTextView.text = event.description
        descriptionTextView.becomeFirstResponder()
    }

}

// MARK: - UITextViewDelegate

extension EditDescriptionViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        event.description = descriptionTextView.text
        descriptionUpdator(event.description ?? "")
    }
    
}
