//
//  LoginValidationError.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 10/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

enum LoginValidationError: Error {
    case fieldIsEmpty
    case emailNotValid
    case passNotValid
}

extension LoginValidationError: MyError {
    func getHash() -> String {
        return self.localizedDescription
    }
}
