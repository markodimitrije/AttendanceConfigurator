//
//  ConfIdApiKeyAuthSupplying.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/06/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation

protocol ConfIdApiKeyAuthSupplying {
    var conferenceId: Int? {get set}
    var apiKey: String? {get set}
    var authentication: String? {get set}
}
