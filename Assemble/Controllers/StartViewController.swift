//
//  StartViewController.swift
//  Assemble
//
//  Created by Will Olson on 9/17/21.
//

import UIKit
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseGoogleAuthUI

class StartViewController: UIViewController {
    
    // MARK: Properties
    
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    
    // MARK: Outlets
    
    @IBOutlet weak var getStartedButton: UIButton!
    

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAuth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            segueToEvents()
        }
    }
    
    // MARK: Navigation
    
    func segueToEvents() {
        performSegue(withIdentifier: "showEvents", sender: nil)
    }

    // MARK: Actions
    
    @IBAction func showLoginView(_ sender: Any) {
        presentLoginSession(sender: self)
    }
    
}

// MARK: FUIAuthDelegate

extension StartViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if authDataResult?.user != nil {
            segueToEvents()
        }
    }
    
    func configureAuth() {
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = self
        
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(),
            FUIGoogleAuth(authUI: authUI)
        ]
        authUI.providers = providers
    }

}
