//
//  FirebaseService.swift
//  Assemble
//
//  Created by Will Olson on 9/30/21.
//

import Foundation
import Firebase
import FirebaseAuth
import CodableFirebase

class FirebaseService {
    
    // MARK: Properties
    
    var databaseReference = Database.database().reference()
    var currentUser: User! = Auth.auth().currentUser
    
    // MARK: CRUD actions
    
    func create(_ newEvent: NewEvent, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        do {
            let data = try FirebaseEncoder().encode(newEvent)
            
            databaseReference.child("events").childByAutoId().setValue(data) { error, databaseReference in
                guard error == nil else {
                    completion(false, error)
                    return
                }
                
                let newEventUid = databaseReference.key!
                self.databaseReference.child("userEvents/\(self.currentUser.uid)/\(newEventUid)").setValue(data)
                self.databaseReference.child("eventOwners/\(newEventUid)/\(self.currentUser.uid)").setValue(true)
                completion(true, nil)
            }
        } catch let error {
            completion(false, error)
        }
    }
    
    func getMyEvents(completion: @escaping (_ events: [Event], _ error: Error?) -> Void) {
        databaseReference.child("userEvents").child(self.currentUser.uid).getData(completion: { error, snapshot in
            guard error == nil else {
                completion([], error)
                return
            }
            guard snapshot.value != nil else {
                completion([], nil)
                return
            }

            let events = snapshot.children.compactMap { singleEventSnapshot -> Event? in
                do {
                    let singleEventSnapshot = singleEventSnapshot as! DataSnapshot
                    let event = try FirebaseDecoder().decode(Event.self, from: singleEventSnapshot.value!)
                    return event
                } catch let error {
                    print(error)
                }
                
                return nil
            }
            
            completion(events, nil)
            return
        })
    }
    
}
