//
//  WebReportedCodesVC.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 15/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit

class WebReportedCodesVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var statsView: StatsView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy private var dataSource = WebReportedCodesDataSourceFactory.make(tableView: tableView,
                                                                         statsView: statsView)
    
    override func viewDidLoad() { super.viewDidLoad()
        self.tableView.dataSource = dataSource
        navigationItem.title = NSLocalizedString(key: "campaign.stats")
        registerCells()
    }
    
    private func registerCells() {
//        tableView.register(UINib(nibName: ChairsTableViewCell.typeName, bundle: nil), forCellReuseIdentifier: ChairsTableViewCell.typeName)
        tableView.register(UINib(nibName: "StatsViewCell", bundle: nil),
                           forCellReuseIdentifier: "StatsViewCell")
    }
    
}
