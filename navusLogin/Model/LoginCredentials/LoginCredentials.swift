//
//  UserInput.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 10/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct LoginCredentials: ILoginCredentials {
    var email = ""
    var password = ""
    func getDictionary() -> [String: String] {
        return ["email": email, "password": password]
    }
}
