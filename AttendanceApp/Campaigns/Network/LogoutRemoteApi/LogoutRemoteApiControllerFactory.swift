//
//  LogoutRemoteApiControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class LogoutRemoteApiControllerFactory {
    static func make() -> ILogoutRemoteApi {
        return LogoutRemoteApi(apiController: ApiController.shared)
    }
}
