//
//  UserStateRepository.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 15/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class UserStateRepository {
    private let userDefaults: UserDefaults
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
}

extension UserStateRepository: IUserStateRepository {
    func login(user: IRemoteUserSession) {
        print("save userSession to repo")
        userDefaults.set(user.getCredentials().email, forKey: "email")
        userDefaults.set(user.getCredentials().password, forKey: "password")
        userDefaults.set(user.getToken(), forKey: "token")
    }
    func logout() {
        userDefaults.set(nil, forKey: "email")
        userDefaults.set(nil, forKey: "password")
        userDefaults.set(nil, forKey: "token")
    }
}
