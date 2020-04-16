//
//  LoginValidationSignalFactory.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 11/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

class LoginValidationSignalFactory {
    
    private let validator: ILoginValidator
    init(validator: ILoginValidator) {
        self.validator = validator
    }
    
    func filterInput(userInput: Observable<ILoginCredentials>) -> Observable<ILoginCredentials> {
        return userInput.filter { (credentials) -> Bool in
            switch self.validator.validate(userInput: credentials) {
                case .valid:
                    return true
                case .invalid(let error):
                    throw error
            }
        }
    }
    
}

