//
//  DefaultHeadersFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class DefaultHeadersFactory {
    static func make(contentType: String = "application/json") -> [String: String] {
        let deviceUdid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let apiKey = conferenceState.apiKey ?? ""
        return ["Api-Key": apiKey,
                "device-id": deviceUdid,
                "Content-Type": contentType]
    }
}

