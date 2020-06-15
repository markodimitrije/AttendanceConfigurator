//
//  BlockScansTableViewCellModel.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 13/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IBlockScansTableViewCellModel {
    var date: Date {get}
    var room: String {get}
    var title: String {get}
    var count: Int {get}
}

struct BlockScansTableViewCellModel: IBlockScansTableViewCellModel {
    let date: Date
    let room: String
    let title: String
    let count: Int
}
