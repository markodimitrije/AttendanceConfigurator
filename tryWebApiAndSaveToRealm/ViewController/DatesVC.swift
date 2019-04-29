//
//  DatesVC.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 29/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import RxCocoa

class DatesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var datesViewmodel: DatesViewmodel!
    
    // OUTPUT
    
//    private (set) var selectedDate = BehaviorRelay<Date?>.init(value: nil)
    
    override func viewDidLoad() { super.viewDidLoad()
        tableView.dataSource = self
        //tableView.delegate = self
        tableView.delegate = datesViewmodel
    }

}

extension DatesVC: UITableViewDataSource {// , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesViewmodel.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = datesViewmodel.data[indexPath.row]
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selected = datesViewmodel.data[indexPath.row]
//        let date = Date.parse(selected)
//        selectedDate.accept(date)
//    }
}

