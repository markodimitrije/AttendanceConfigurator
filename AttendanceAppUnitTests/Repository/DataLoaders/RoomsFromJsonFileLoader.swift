//
//  RoomsFromJsonFileLoader.swift
//  AttendanceAppUnitTests
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation
@testable import AttendanceApp

class RoomsFromJsonFileLoader {
    static func make(filename: String) -> [IRoom] {
        let bundle = Bundle(for: self)
        let jsonData = JsonBundleDataProvider().jsonData(filename: filename, inBundle: bundle)
        let roomsObject = try! JSONDecoder().decode(Rooms.self, from: jsonData)
        return roomsObject.data
    }
}
