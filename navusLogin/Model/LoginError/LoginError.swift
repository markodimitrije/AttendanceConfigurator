//
//  LoginError.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 10/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

enum LoginError: Error {
    case noConnection
    case unauthorized
    case httpError
    case unprocessableEntity
    case badParsing
}

extension LoginError: MyError {
    func getHash() -> String {
        return self.localizedDescription
    }
}
