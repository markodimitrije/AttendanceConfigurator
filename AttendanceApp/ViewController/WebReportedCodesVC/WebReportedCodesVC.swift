//
//  WebReportedCodesVC.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 15/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit

class WebReportedCodesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy private var dataSource = WebReportedCodesDataSourceFactory.make(tableView: tableView)
    
    override func viewDidLoad() { super.viewDidLoad()
        self.tableView.dataSource = dataSource
        navigationItem.title = "Synced codes"
    }
}
