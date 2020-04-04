//
//  WebReportedCodesVC.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 15/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Realm

class WebReportedCodesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy private var dataSource = WebReportedCodesDataSource.init(tableView: tableView)
    
    override func viewDidLoad() { super.viewDidLoad()
        self.tableView.dataSource = dataSource
        navigationItem.title = "Synced codes"
    }
}

class WebReportedCodesDataSource: NSObject, UITableViewDataSource {
    
    private var data = [String]() {
        didSet {
            self.tableView.reloadData()
        }
    } // hooked with realm in func: "hookUpDataFromRealm"
    
    private var tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.hookUpDataFromRealm()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    private func hookUpDataFromRealm() {
        RealmDataPersister.shared.getRealmWebReportedCodes().subscribeOn(MainScheduler.init())
            .subscribe(onNext: { [weak self] results in
            guard let sSelf = self else {return}
                let reports = results.toArray().sorted(by: { (rCode1, rCode2) -> Bool in
                    return (rCode1.date ?? Date.now) > (rCode2.date ?? Date.now)
                })
                sSelf.data = reports.map {$0.code}.map(trimmedToSixCharactersCode(code:))
        }).disposed(by: bag)
    }
    
    private let bag = DisposeBag()
}
