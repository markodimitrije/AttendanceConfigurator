//
//  ICampaignResourcesFromDataFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol ICampaignResourcesFromDataFactory {
    func make(data: Data) throws -> ICampaignResources
}
