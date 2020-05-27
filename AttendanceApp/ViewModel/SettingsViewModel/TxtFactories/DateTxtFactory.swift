//
//  DateTxtFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IDateTxtFactory {
    func getText(date: Date?) -> String
}

struct DateTxtFactory: IDateTxtFactory {
    func getText(date: Date?) -> String {
        if let date = date {
            return date.toString(format: "yyyy-MM-dd") ?? "error converting to date"
        } else {
            return "Select date"
        }
//        let availableDates = blockRepo.getAvailableDates(roomId: roomId)
//        if availableDates.count > 1 {
//
//        } else {
//            return availableDates.first!.toString(format: "yyyy-MM-dd") ?? "error converting to date"
//        }
    }
}
