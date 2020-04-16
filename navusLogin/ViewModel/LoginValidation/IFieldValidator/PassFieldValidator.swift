//
//  PassFieldValidator.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 13/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class PassFieldValidator: IFieldValidator {
    func isValid(text: String) -> ValidationEnum {
        if text.count >= 6 {
            return .valid
        } else {
            return .invalid(LoginValidationError.passNotValid)
        }
    }
}
