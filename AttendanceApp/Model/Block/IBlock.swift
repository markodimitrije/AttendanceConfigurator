//
//  IBlock.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 25/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IBlock {
    func getId() -> Int
    func getLocationId() -> Int
    func getName() -> String
    func getStartsAt() -> Date
    func getEndsAt() -> Date
    func getClosed() -> Bool
}
