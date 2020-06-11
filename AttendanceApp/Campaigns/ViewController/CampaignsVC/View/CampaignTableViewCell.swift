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
        
        //imgView.kf.setImage(with: URL(string: item.logo ?? ""), placeholder: CAMPAIGN_DEF_IMG)
        imgView.kf.setImage(with: URL(string: item.logo ?? ""))
        titleLbl.text = item.title
    }
}

class CampaignTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
