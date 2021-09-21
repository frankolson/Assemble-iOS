//
//  Event.swift
//  Assemble
//
//  Created by Will Olson on 9/20/21.
//

import Foundation

struct NewEvent: Codable {
    var title: String?
    var description: String?
    var startDate: String?
    var startTime: String?
    var endDate: String?
    var endTime: String?
}

struct Event: Codable {
    let uid: String
    var title: String
    var description: String?
    var startDate: String?
    var startTime: String?
    var endDate: String?
    var endTime: String?
}
