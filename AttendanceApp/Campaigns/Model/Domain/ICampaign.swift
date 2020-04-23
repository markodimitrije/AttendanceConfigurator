//
//  ICampaign.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol ICampaign {
    var id: String {get set}
    var name: String {get set}
    var description: String? {get set}
    var logo: String? {get set}
    var conferenceId: Int {get set}
    var restrictedAccess: Bool {get set}
    var createdAt: Date {get set}
    var updatedAt: Date? {get set}
    var deletedAt: Date? {get set}
    var image: UIImage? {get set}
}
