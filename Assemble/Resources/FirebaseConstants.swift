//
//  FirebaseConstants.swift
//  Assemble
//
//  Created by Will Olson on 9/18/21.
//

// MARK: - Constants

struct Constants {

    // MARK: EventFields

    struct EventFields {
        static let title = "title"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let startTime = "startTime"
        static let endTime = "endTime"
    }
    
    struct URL {
        static let scheme = "https"
        static let host = "cyberhoodie.com"
        static var baseURL: String {
            return "\(scheme)://\(host)"
        }
        static let dynamicLinksURI = "https://cyberhoodie.page.link"
        
        func eventAcceptInvitation(event: Event) -> String {
            return "/events/\(event.uid!)/accept-invitation"
        }
    }
    
    struct Apple {
        static let appStoreId = "962194608"
        static let bundleId = "com.cyberhoodie.Assemble"
    }
}
