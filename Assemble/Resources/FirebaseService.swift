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
        let updatedEvent = addInviteCodeToEvent(newEvent)
        
        do {
            let data = try FirebaseEncoder().encode(updatedEvent)
            print(data)
            
            databaseReference.child("events").childByAutoId().setValue(data) { error, databaseReference in
                guard error == nil else {
                    completion(false, error)
                    return
                }
                
                let newEventUid = databaseReference.key!
                
                self.addUserEvent(eventUid: newEventUid, data: data)
                self.addOwnedEvent(eventUid: newEventUid)
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
                let singleEventSnapshot = singleEventSnapshot as! DataSnapshot
                let event: Event? = decode(from: singleEventSnapshot)
                return event
            }
            
            completion(events, nil)
            return
        })
    }
    
    func addInviteCodeToEvent(_ event: NewEvent) -> NewEvent {
        event.inviteCode = UUID().uuidString
        return event
    }
    
    private func addUserEvent(eventUid: String, data: Any) {
        self.databaseReference.child("userEvents/\(self.currentUser.uid)/\(eventUid)").setValue(data)
    }
    
    private func addOwnedEvent(eventUid: String) {
        self.databaseReference.child("eventOwners/\(eventUid)/\(self.currentUser.uid)").setValue(true)
    }
    
}
