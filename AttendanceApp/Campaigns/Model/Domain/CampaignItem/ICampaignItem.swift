//
//  ICampaignItem.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 20/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol ICampaignItem {
    var id: String {get}
    var confId: String {get}
    var title: String {get}
    var description: String {get}
    var logo: String? {get}
}
