//
//  LogoutRemoteApi.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 18/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

class LogoutRemoteApi: ILogoutRemoteApi {
    private let apiController: ApiController
    private let userState: IUserStateRepository
    init(apiController: ApiController, userState: IUserStateRepository) {
        self.apiController = apiController
        self.userState = userState
    }
    
    func logout() -> Observable<Data> {
        let headers = DefaultHeadersFactory.make().createHeaders()
        return self.apiController
            .buildRequest(method: "POST",
                          pathComponent: "logout",
                          headers: headers)
    }
}
