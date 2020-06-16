//
//  BlockScansCell.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 13/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class BlockScansCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var roomLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var countLbl: ScanBtn!
    
    public func configure(with model: IBlockScansTableViewCellModel) {
        dateLbl.text = model.date.toString(format: Date.defaultFormatString) ?? ""
        roomLbl.text = model.room
        titleLbl.text = model.title
        countLbl.scans = model.count
    }
    
}
