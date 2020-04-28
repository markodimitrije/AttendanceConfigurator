//
//  LogoutHandlerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class LogoutHandlerFactory {
    static func make() -> ILogoutHandler {
        LogoutHandler(logoutWorker: LogoutWorkerFactory.make(),
                      alertInfo: LogoutAlertInfoFactory.make())
    }
}
