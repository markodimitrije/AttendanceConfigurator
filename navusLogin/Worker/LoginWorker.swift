//
//  LoginWorker.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

extension LoginWorker: ILoginWorker {
    func loginWith(input: Observable<ILoginCredentials>) -> Observable<IRemoteUserSession> {
        return loginRemoteApi.loginWith(sig: input)
    }
    func received(userSession: IRemoteUserSession) {
        userState.login(user: userSession)
    }
}

class LoginWorker {
    private let loginRemoteApi: ILoginRemoteApi
    private let userState: IUserStateRepository
    init(loginRemoteApi: ILoginRemoteApi, userState: IUserStateRepository) {
        self.loginRemoteApi = loginRemoteApi
        self.userState = userState
    }
}
