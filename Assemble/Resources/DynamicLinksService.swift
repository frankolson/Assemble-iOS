//
//  DynamicLinksService.swift
//  Assemble
//
//  Created by Will Olson on 10/1/21.
//

import Foundation
import Firebase

class DynamicLinksService {

    static func generateEventInviteLink(_ event: Event, completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
        let defaultURL = URL(string: Constants.URL.baseURL)!
        
        guard let linkParameter = generateEventUrl(event) else {
            completion(defaultURL, nil)
            return
        }
        let linkBuilder = DynamicLinkComponents(link: linkParameter, domainURIPrefix: Constants.URL.dynamicLinksURI)
        
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: Constants.Apple.bundleId)
        linkBuilder?.iOSParameters?.appStoreID = Constants.Apple.appStoreId
        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder?.socialMetaTagParameters?.title = "Event invite from Assemble"
        
        linkBuilder?.shorten(completion: { url, warnings, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let warnings = warnings {
                for warning in warnings {
                    print("FDL warning: \(warning)")
                }
                return
            }
            
            completion(url, nil)
        })
    }
    
    static func generateEventUrl(_ event: Event) -> URL? {
        var components = URLComponents()
        let queryItem = URLQueryItem(name: "eventUid", value: event.uid)

        components.scheme = Constants.URL.scheme
        components.host = Constants.URL.host
        components.path = Constants.URL.eventsPath
        components.queryItems = [queryItem]
        
        return components.url
    }

}
