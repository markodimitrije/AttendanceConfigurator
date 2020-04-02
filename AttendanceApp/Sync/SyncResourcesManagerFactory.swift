//
//  SyncResourcesManagerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 02/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class SyncResourcesManagerFactory {
    static func make(confId: Int) -> ISyncResourcesManager {
        let resourceState = ResourceStateFactory.make(confId: confId)
        return SyncResourcesManager(dataAccess: DataAccess.shared,
                                    resourceState: resourceState)
    }
}
