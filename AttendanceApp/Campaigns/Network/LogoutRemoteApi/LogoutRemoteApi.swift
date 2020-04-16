//
//  LogoutRemoteApi.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class LogoutRemoteApi: ILogoutRemoteApi {
    private let apiController: IApiController
    init(apiController: IApiController) {
        self.apiController = apiController
    }
    func logout() {
        //TODO marko
    }
}
