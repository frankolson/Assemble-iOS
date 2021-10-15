//
//  Event.swift
//  Assemble
//
//  Created by Will Olson on 9/20/21.
//

import Foundation

class EventBase: Codable {
    var title: String?
    var description: String?
    var startDate: Date?
    var startTime: TimeInterval?
    var endDate: Date?
    var endTime: TimeInterval?
    var inviteCode: String?
    
    var formattedStartDate: String? {
        guard let startDateIso = startDate else { return nil }
        return formatedDate(startDateIso)
    }
    
    var formattedEndDate: String? {
        guard let endDateIso = endDate else { return nil }
        return formatedDate(endDateIso)
    }
    
    var formattedStartTime: String? {
        guard let startTimeIso = startTime else { return nil }
        return formatedTime(startTimeIso)
    }
    
    var formattedEndTime: String? {
        guard let endTimeIso = endTime else { return nil }
        return formatedTime(endTimeIso)
    }
    
    // MARK: Date formatting helpers
    
    private func formatedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        return dateFormatter.string(from: date)
    }
    
    private func formatedTime(_ time: TimeInterval) -> String {
        let epochDate = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: epochDate)
    }
}

// MARK: - Models

class NewEvent: EventBase {}

class Event: EventBase, FirebaseCodable {
    var uid: String!
    
    var inviteURL: URL? {
        var components = URLComponents()
        let queryItem = URLQueryItem(name: "inviteCode", value: inviteCode)

        components.scheme = Constants.URL.scheme
        components.host = Constants.URL.host
        components.path = Constants.URL().eventAcceptInvitation(event: self)
        components.queryItems = [queryItem]
        
        return components.url
    }
    
    func setUid(_ uid: String) {
        self.uid = uid
    }
    
    
}
