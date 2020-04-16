//
//  LoginValidatorFactory.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 13/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class LoginValidatorFactory {
    static func make() -> ILoginValidator {
        let validatorsDict = ["email": EmailFieldValidator(),
                              "password": PassFieldValidator()] as [String : IFieldValidator]
        return LoginValidator(validators: validatorsDict)
    }
}
