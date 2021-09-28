//
//  FirebaseCodable.swift
//  Assemble
//
//  Created by Will Olson on 9/27/21.
//

import Foundation
import Firebase
import CodableFirebase

// Solution from: https://github.com/alickbass/CodableFirebase/issues/31#issuecomment-457371128

protocol FirebaseCodable: Codable {
    var uid: String! {get set}
    mutating func setUid(_ uid: String)
}

extension FirebaseCodable {
    mutating func setUid(_ uid: String) {}
}

func decode<T: FirebaseCodable>(from snapshot: DataSnapshot) -> T? {
    if let data = snapshot.value {
        do {
            var object = try FirebaseDecoder().decode(T.self, from: data)
            object.setUid(snapshot.key)
            return object
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    return nil
}
