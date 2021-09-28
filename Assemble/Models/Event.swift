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
    var startTime: Int?
    var endDate: String?
    var endTime: Int?
    
    var formattedStartDate: String? {
        guard let startDateIso = startDate else { return nil }
        return formatIsoDate(startDateIso)
    }
    
    var formattedEndDate: String? {
        guard let endDateIso = endDate else { return nil }
        return formatIsoDate(endDateIso)
    }
    
    var formattedStartTime: String? {
        guard let startTimeIso = startTime else { return nil }
        return formatEpochTime(startTimeIso)
    }
    
    var formattedEndTime: String? {
        guard let endTimeIso = endTime else { return nil }
        return formatEpochTime(endTimeIso)
    }
    
    // MARK: Date formatting helpers
    
    private func formatIsoDate(_ isoDateString: String) -> String? {
        let isoDateFormatter = ISO8601DateFormatter()
        let isoDate = isoDateFormatter.date(from: isoDateString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        if let isoDate = isoDate {
            return dateFormatter.string(from: isoDate)
        } else {
            return nil
        }
    }
    
    private func formatEpochTime(_ epochTime: Int) -> String? {
        let epochTimeInterval = TimeInterval(epochTime)
        let epochDate = Date(timeIntervalSince1970: epochTimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: epochDate)
    }
}

struct Event: FirebaseCodable {
    var uid: String!
    var title: String
    var description: String?
    var startDate: String?
    var startTime: Int?
    var endDate: String?
    var endTime: Int?
    
    var formattedStartDate: String? {
        guard let startDateIso = startDate else { return nil }
        return formatIsoDate(startDateIso)
    }
    
    var formattedEndDate: String? {
        guard let endDateIso = endDate else { return nil }
        return formatIsoDate(endDateIso)
    }
    
    var formattedStartTime: String? {
        guard let startTimeIso = startTime else { return nil }
        return formatEpochTime(startTimeIso)
    }
    
    var formattedEndTime: String? {
        guard let endTimeIso = endTime else { return nil }
        return formatEpochTime(endTimeIso)
    }
    
    mutating func setUid(_ uid: String) {
        self.uid = uid
    }
    
    // MARK: Date formatting helpers
    
    private func formatIsoDate(_ isoDateString: String) -> String? {
        let isoDateFormatter = ISO8601DateFormatter()
        let isoDate = isoDateFormatter.date(from: isoDateString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        if let isoDate = isoDate {
            return dateFormatter.string(from: isoDate)
        } else {
            return nil
        }
    }
    
    private func formatEpochTime(_ epochTime: Int) -> String? {
        let epochTimeInterval = TimeInterval(epochTime)
        let epochDate = Date(timeIntervalSince1970: epochTimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: epochDate)
    }
}
