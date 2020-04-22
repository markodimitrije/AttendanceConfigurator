//
//  CampaignTableViewCell.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 22/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol ICampaignCellUpdate {
    func update(item: ICampaignItem)
}

extension CampaignTableViewCell: ICampaignCellUpdate {
    func update(item: ICampaignItem) {
        self.imageView?.image = item.image
        self.titleLbl?.text = item.title
        self.descLbl?.text = item.description
    }
}

class CampaignTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
