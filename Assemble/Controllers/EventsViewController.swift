//
//  EventsViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/17/21.
//

import UIKit
import FirebaseAuth

class EventsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func logout(_ sender: Any) {
        do {
            print("Attempting to log out")
            try Auth.auth().signOut()
            print("Logged out")
            
            performSegue(withIdentifier: "logout", sender: nil)
        } catch {
            print("unable to sign out: \(error)")
        }
    }
    
}
