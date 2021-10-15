//
//  DynamicLinksService.swift
//  Assemble
//
//  Created by Will Olson on 10/1/21.
//

import Foundation
import Firebase

class DynamicLinksService {

    static func generateLink(_ url: URL, title: String, completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
        let linkBuilder = DynamicLinkComponents(link: url, domainURIPrefix: Constants.URL.dynamicLinksURI)
        
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: Constants.Apple.bundleId)
        linkBuilder?.iOSParameters?.appStoreID = Constants.Apple.appStoreId
        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder?.socialMetaTagParameters?.title = title
        
        linkBuilder?.shorten(completion: { url, warnings, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let warnings = warnings {
                for warning in warnings {
                    print("FDL warning: \(warning)")
                }
            }
            
            completion(url, nil)
        })
    }

}
