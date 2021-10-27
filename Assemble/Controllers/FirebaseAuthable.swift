//
//  FirebaseAuthable.swift
//  Assemble
//
//  Created by Will Olson on 10/27/21.
//

import Foundation
import FirebaseAuthUI

func presentLoginSession(sender: UIViewController) {
    let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
    sender.present(authViewController, animated: true, completion: nil)
}
