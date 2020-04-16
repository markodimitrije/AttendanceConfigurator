//
//  ILoginCredentials.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 10/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol DictionaryRepresentable {
    func getDictionary() -> [String: String]
}

protocol ILoginCredentials: DictionaryRepresentable {
    var email: String { get }
    var password: String { get }
}

extension ILoginCredentials {
    func getDictionary() -> [String : String] {
        return ["email": email, "password": password]
    }
}
