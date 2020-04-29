//
//  CampaignResourceError.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

enum CampaignResourcesError {
    case badData
}

extension CampaignResourcesError: MyError {
    func getHash() -> String {self.localizedDescription}
}
