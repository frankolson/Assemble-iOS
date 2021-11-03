//
//  Person.swift
//  Assemble
//
//  Created by Will Olson on 11/3/21.
//

import Foundation

class PersonBase: Codable {
    var uid: String!
    var email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}

// MARK: - Models

class Person: PersonBase, FirebaseCodable {
    func setUid(_ uid: String) {
        self.uid = uid
    }
}
