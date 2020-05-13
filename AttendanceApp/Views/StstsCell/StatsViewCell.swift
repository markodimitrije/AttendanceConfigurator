//
//  StatsViewCell.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 13/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol IBlockStatsTableViewCellModel {
    var title: String {get}
    var date: Date {get}
    var count: String {get}
}

struct BlockStatsTableViewCellModel: IBlockStatsTableViewCellModel {
    let title: String
    let date: Date
    let count: String
}

class StatsViewCell: UITableViewCell {
   
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    public func configure(with model: IBlockStatsTableViewCellModel) {
        titleLbl.text = model.title
        dateLbl.text = model.date.toString(format: Date.defaultFormatString) ?? ""
        countLbl.text = model.count
    }
    
}
