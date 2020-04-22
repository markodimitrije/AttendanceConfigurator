//
//  CampaignTableViewCell.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 22/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit
import Kingfisher

protocol ICampaignCellUpdate {
    func update(item: ICampaignItem)
}

extension CampaignTableViewCell: ICampaignCellUpdate {
    func update(item: ICampaignItem) {
        
        imgView.image = item.image
        titleLbl.text = item.title
        descLbl.text = item.description
    }
}

class CampaignTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
