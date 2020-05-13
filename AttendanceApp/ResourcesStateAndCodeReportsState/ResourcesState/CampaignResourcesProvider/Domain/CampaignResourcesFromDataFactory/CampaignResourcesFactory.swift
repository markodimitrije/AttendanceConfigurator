//
//  CampaignResourcesFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class CampaignResourcesFactory: ICampaignResourcesFromDataFactory {
    func make(data: DataProtocol) -> ICampaignResources {
        // hard-coded
        //let data = JsonBundleDataProvider().jsonData(filename: "Resources", inBundle: Bundle.main)
        let data = JsonBundleDataProvider().jsonData(filename: "ResourcesForScan",
                                                     inBundle: Bundle.main)
        return try! CampaignResources(data: data) // TODO: should handle errors
    }
}

protocol DataProtocol {}
extension Data: DataProtocol {}
