//
//  DeepLinkHandler.swift
//  Assemble
//
//  Created by Will Olson on 10/31/21.
//

import Foundation
import Firebase

class DeepLinkHandler {
    enum DeepLink: Equatable {
        case home
        case addToGuestList(eventUid: String, inviteCode: String)
    }

    // Parse url
    func parseComponents(from url: URL) -> DeepLink? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        guard components.path.contains(Constants.URL.eventAcceptInvitationPath) else { return .home }
        guard let queryItems = components.queryItems,
              let eventUid = queryItems.filter({$0.name == "eventUid"}).first?.value,
              let inviteCode = queryItems.filter({$0.name == "inviteCode"}).first?.value else { return nil }


        return .addToGuestList(eventUid: eventUid, inviteCode: inviteCode)
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("That's weird. My dynamic link object has no url.")
            return
        }
        guard dynamicLink.matchType == .unique else { return }
        guard let deepLink = DeepLinkHandler().parseComponents(from: url) else { return }
        
        DynamicLinksProcessing.shared.deepLink = deepLink
    }
}
