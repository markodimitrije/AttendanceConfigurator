//
//  LoginValidator.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 10/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol ILoginValidator {
    func validate(userInput: ILoginCredentials) -> ValidationEnum
}

struct LoginValidator {
    fileprivate let validators: [String: IFieldValidator]
    init(validators: [String: IFieldValidator]) {
        self.validators = validators
    }
}

extension LoginValidator: ILoginValidator {
    func validate(userInput: ILoginCredentials) -> ValidationEnum {
        var fieldsValidationSet = Set<ValidationEnum>()
        let userInputDict = userInput.getDictionary()
        _ = userInputDict.keys.map { key in
            let valid = validators[key]!.isValid(text: userInputDict[key] ?? "")
            fieldsValidationSet.insert(valid)
        }
        let invalid = fieldsValidationSet.filter { (field) -> Bool in
            field != .valid
        }
        if invalid.isEmpty {
            return .valid
        } else {
            return invalid.first!
        }
    }
}
