//
//  IUserStateRepository.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 15/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ICurrentUser {
    func getToken() -> SignInToken
}

protocol IUserStateRepository: ICurrentUser {
    func login(user: IRemoteUserSession)
    func logout()
    func getToken() -> SignInToken
}
