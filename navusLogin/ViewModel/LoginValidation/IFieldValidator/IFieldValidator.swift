//
//  IFieldValidator.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 13/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol IFieldValidator {
    func isValid(text: String) -> ValidationEnum
}
