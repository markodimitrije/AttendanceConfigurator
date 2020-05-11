//
//  BlockReport.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 18/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation

struct BlockReport: CustomStringConvertible {
    
    var location_id: Int
    var block_id: Int
    var battery_level: Int
    var battery_status: String
    var app_active: Bool
    
    func getPayload() -> [(String, String)] {
        let appActive = app_active ? "1" : "0"
        return [
            ("location_id", "\(location_id)"),
            ("block_id", "\(block_id)"),
            ("battery_level", "\(battery_level)"),
            ("battery_status", "\(battery_status)"),
            ("app_active", appActive)
        ]
    }
    
    var description: String {
        return "location_id = \(location_id), block_id = \(block_id), battery_level = \(battery_level), battery_status = \(battery_status), app_active = \(app_active))"
    }
}
