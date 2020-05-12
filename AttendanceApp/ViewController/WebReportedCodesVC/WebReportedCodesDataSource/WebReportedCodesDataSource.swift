//
//  WebReportedCodesDataSource.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class WebReportedCodesDataSource: NSObject, UITableViewDataSource {
    
    private var stats: StatsProtocol = Stats() {
        didSet {
            self.statsView.update(stats: stats)
        }
    }
    
    private var data = [CodeReportCellModel]() {
        didSet {
            self.tableView.reloadData()
        }
    } // hooked with realm in func: "hookUpDataFromRealm"
    
    private let tableView: UITableView
    private let statsView: StatsViewRendering
    private let repository: ICodeReportsRepository
    
    init(tableView: UITableView, statsView: StatsViewRendering, repository: ICodeReportsRepository) {
        self.tableView = tableView
        self.repository = repository
        self.statsView = statsView
        super.init()
        self.hookUpCodeReports()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "code= \(data[indexPath.row].code)" + " acc= \(data[indexPath.row].accepted)" + " synced= \(data[indexPath.row].reported)"
        return cell
    }
    
    private func hookUpCodeReports() {
        
        self.repository.getObsCodeReports()
            .subscribeOn(MainScheduler.init())
            .subscribe(onNext: { [weak self] reports in
            guard let sSelf = self else {return}
                sSelf.data = reports.map(CodeReportCellModelFactory.make)
                sSelf.stats = StatsFactory.make(repository: sSelf.repository)
            })
            .disposed(by: bag)
    }
    
    private let bag = DisposeBag()
}

struct StatsFactory {
    static func make(repository: ICodeReportsRepository) -> StatsProtocol {
        Stats(totalTitle: NSLocalizedString("total.title", comment: ""),
              totalValue: "3232",
              approvedTitle: NSLocalizedString("approved.title", comment: ""),
              approvedValue: "3230/3232",
              rejectedTitle: NSLocalizedString("rejected.title", comment: ""),
              rejectedValue: "2/3232",
              syncedTitle: NSLocalizedString("synced.title", comment: ""),
              syncedValue: "3232")
    }
}
