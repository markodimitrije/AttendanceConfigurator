//
//  ValidationEnum.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 10/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

enum ValidationEnum { // rename to LoginValidation
    case valid
    case invalid(Error)
}

func ==(lhs: ValidationEnum, rhs: ValidationEnum) -> Bool {
    switch (lhs, rhs) {
    
    case (let .invalid(lhsErr), let .invalid(rhsErr)):
        return lhsErr.localizedDescription == rhsErr.localizedDescription
    
    case (.valid, .invalid), (.invalid, .valid) :
        return false

    case (.valid, .valid):
        return true
    }
}

extension ValidationEnum: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .valid:
            hasher.combine("valid".hashValue)
        case .invalid(let err):
            hasher.combine("\(err.localizedDescription)".hashValue)
        }
    }
}
