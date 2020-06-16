//
//  CampaignStatsVC.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 15/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit

class CampaignStatsVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var statsView: StatsView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy private var dataSource = CampaignStatsDataSourceFactory.make(tableView: tableView,
                                                                      statsView: statsView)
    var logoProvider: ICampaignLogoProvider!
    
    override func viewDidLoad() { super.viewDidLoad()
        self.tableView.dataSource = dataSource
        navigationItem.title = NSLocalizedString(key: "campaign.stats")
        registerCells()
        logoImgView.image = logoProvider.getLogo().image

    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "BlockScansCell", bundle: nil),
                           forCellReuseIdentifier: "BlockScansCell")
    }
    
    
    
}
