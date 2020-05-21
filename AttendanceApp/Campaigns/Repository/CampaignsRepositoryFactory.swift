//
//  CampaignsRepositoryFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CampaignsRepositoryFactory {
    static func make() -> ICampaignsRepository {
        let genericRepo = GenMuttableRepository()
        return CampaignsRepository(genericRepo: genericRepo)
    }
}
