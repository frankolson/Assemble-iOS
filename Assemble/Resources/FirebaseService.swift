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
    
    func getEvent(_ uid: String, completion: @escaping (_ event: Event?, _ error: Error?) -> Void) {
        databaseReference.child("events").child(uid).getData(completion: { error, snapshot in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard snapshot.value != nil else {
                completion(nil, nil)
                return
            }

            let event: Event? = decode(from: snapshot)
            completion(event, nil)
            return
        })
    }
    
    func getEventGuestList(_ eventUid: String, completion: @escaping (_ events: [Person], _ error: Error?) -> Void) {
        databaseReference.child("eventAttendees").child(eventUid).getData(completion: { error, snapshot in
            guard error == nil else {
                completion([], error)
                return
            }
            guard snapshot.value != nil else {
                completion([], nil)
                return
            }

            let people = snapshot.children.compactMap { singleEventSnapshot -> Person? in
                let singleEventSnapshot = singleEventSnapshot as! DataSnapshot
                let person: Person? = decode(from: singleEventSnapshot)
                return person
            }
            
            completion(people, nil)
            return
        })
    }
    
    func addPersonToGuestList(_ person: Person, event: Event, inviteCode: String, completion: @escaping (_ error: Error?) -> Void) {
        if event.inviteCode == inviteCode {
            do {
                let data = try FirebaseEncoder().encode(event)
                
                self.addUserEvent(eventUid: event.uid, data: data)
                self.addAttendeeToGuestList(person: person, eventUid: event.uid)
                completion(nil)
            } catch let error {
                completion(error)
            }
        } else {
            completion(InvalidInviteCodeError())
        }
    }
    
    func addInviteCodeToEvent(_ event: NewEvent) -> NewEvent {
        event.inviteCode = UUID().uuidString
        return event
    }
    
    private func addAttendeeToGuestList(person: Person, eventUid: String) {
        let data = try! FirebaseEncoder().encode(person)
        self.databaseReference.child("eventAttendees/\(eventUid)/\(person.uid!)").setValue(data)
    }
    
    private func addUserEvent(eventUid: String, data: Any) {
        self.databaseReference.child("userEvents/\(self.currentUser.uid)/\(eventUid)").setValue(data)
    }
    
    private func addOwnedEvent(eventUid: String) {
        self.databaseReference.child("eventOwners/\(eventUid)/\(self.currentUser.uid)").setValue(true)
    }
    
}

struct InvalidInviteCodeError: Error {
    let description = "Provided invite code does not match the event's invite code"
}

extension InvalidInviteCodeError: LocalizedError {
    var errorDescription: String? {
        return description
    }
}
