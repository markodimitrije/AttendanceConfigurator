//
//  IErrorHandler.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IErrorHandler {
    func handle(error: Error)
}
