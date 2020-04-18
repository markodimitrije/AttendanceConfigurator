//
//  LoginResponsePayload.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 18/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

struct LoginResponsePayload: Codable {
    var data: SignInToken
}
