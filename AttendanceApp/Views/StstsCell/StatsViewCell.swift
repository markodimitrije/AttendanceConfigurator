//
//  StatsViewCell.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 13/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol IBlockStatsTableViewCellModel {
    var date: Date {get}
    var room: String {get}
    var title: String {get}
    var count: String {get}
}

struct BlockStatsTableViewCellModel: IBlockStatsTableViewCellModel {
    let date: Date
    let room: String
    let title: String
    let count: String
}

class StatsViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var roomLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    
    public func configure(with model: IBlockStatsTableViewCellModel) {
        dateLbl.text = model.date.toString(format: Date.defaultFormatString) ?? ""
        roomLbl.text = model.room
        titleLbl.text = model.title
        countLbl.text = model.count
    }
    
}
