//
//  IRoom.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IRoom {
    func getId() -> Int
    func getOrder() -> Int
    func getName() -> String
}
