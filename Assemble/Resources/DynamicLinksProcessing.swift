//
//  DynamicLinksProcessing.swift
//  Assemble
//
//  Created by Will Olson on 10/1/21.
//

import Foundation
import Firebase

class DynamicLinksProcessing {
    static let shared = DynamicLinksProcessing()
    var deepLink: DeepLinkHandler.DeepLink?
}
