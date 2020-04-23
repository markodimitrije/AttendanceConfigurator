//
//  DatesViewController.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 29/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import RxCocoa

class DatesViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    
    var datesViewmodel: DatesViewmodel!
    
    override func viewDidLoad() { super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = datesViewmodel
    }

}

extension DatesViewController: UITableViewDataSource {// , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesViewmodel.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let date = datesViewmodel.data[indexPath.row]
        cell.textLabel?.text = date.toString(format: "yyyy-MM-dd")//"\(date)"
        return cell
    }

}

