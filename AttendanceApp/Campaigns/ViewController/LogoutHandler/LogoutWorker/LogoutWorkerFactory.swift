//
//  LogoutWorkerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class LogoutWorkerFactory {
    static func make() -> ILogoutWorker {
        LogoutWorker(logoutRemoteApi: LogoutRemoteApiControllerFactory.make(),
                     userState: UserStateRepository(),
                     genericRepo: GenMuttableRepository(),
                     campaignSettingsRepo: CampaignSettingsRepository())
    }
}
