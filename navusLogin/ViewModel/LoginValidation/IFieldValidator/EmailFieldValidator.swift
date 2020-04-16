//
//  EmailFieldValidator.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 13/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class EmailFieldValidator: IFieldValidator {
    func isValid(text: String) -> ValidationEnum {
        return isValidEmail(testStr: text) ? ValidationEnum.valid : ValidationEnum.invalid(LoginValidationError.emailNotValid)
    }
    private func isValidEmail(testStr:String?) -> Bool {
        guard let testStr = testStr else {return false}
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
