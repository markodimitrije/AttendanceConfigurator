//
//  CampaignStatsVC.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 15/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit

class CampaignStatsVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var statsView: StatsView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy private var dataSource = CampaignStatsDataSourceFactory.make(tableView: tableView,
                                                                         statsView: statsView)
    
    override func viewDidLoad() { super.viewDidLoad()
        self.tableView.dataSource = dataSource
        navigationItem.title = NSLocalizedString(key: "campaign.stats")
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "BlockScansCell", bundle: nil),
                           forCellReuseIdentifier: "BlockScansCell")
    }
    
}
