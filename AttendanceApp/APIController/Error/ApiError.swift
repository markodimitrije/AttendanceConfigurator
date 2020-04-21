//
//  ApiError.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case invalidJson
    case unauthorized
    case badRequest
    case serverFailure
}

extension ApiError: MyError {
    func getHash() -> String {
        return self.localizedDescription
    }
}
