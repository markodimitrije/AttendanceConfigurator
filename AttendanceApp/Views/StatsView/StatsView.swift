//
//  StatsView.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol StatsViewRendering {
    func update(stats: StatsProtocol)
}

class StatsView: UIView, StatsViewRendering {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var totalTitleLbl: UILabel!
    @IBOutlet weak var approvedTitleLbl: UILabel!
    @IBOutlet weak var rejectedTitleLbl: UILabel!
    @IBOutlet weak var syncedTitleLbl: UILabel!
    
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var approvedValueLbl: UILabel!
    @IBOutlet weak var rejectedValueLbl: UILabel!
    @IBOutlet weak var syncedValueLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("StatsView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func update(stats: StatsProtocol) {
        totalTitleLbl.text = stats.totalTitle
        totalValueLbl.text = stats.totalValue
        approvedTitleLbl.text = stats.approvedTitle
        approvedValueLbl.text = stats.approvedValue
        rejectedTitleLbl.text = stats.rejectedTitle
        rejectedValueLbl.text = stats.rejectedValue
        syncedTitleLbl.text = stats.syncedTitle
        syncedValueLbl.text = stats.syncedValue
    }
    
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
