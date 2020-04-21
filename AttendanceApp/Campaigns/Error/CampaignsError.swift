//
//  CampaignsError.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

enum CampaignsError: Error {
    case unreadable
    case invalidKey
    case unauthorized
    case empty
}
