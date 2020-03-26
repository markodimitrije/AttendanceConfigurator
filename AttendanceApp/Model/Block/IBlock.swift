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
    func getName() -> String
    func getLocationId() -> Int
    func getStartsAt() -> Date
    func getEndsAt() -> Date
    func get_Starts_At() -> String
    func get_Ends_At() -> String
    func getClosed() -> Bool
}
