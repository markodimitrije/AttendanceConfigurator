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
    
    private var blockData = [IBlockStatsTableViewCellModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let tableView: UITableView
    private let statsView: StatsViewRendering
    
    private let codeReportsRepo: ICodeReportsRepository
    private var statsFactory: IStatsFactory
    private let cellModelsFactory: IBlockScansCellModelsFactory
    
    init(tableView: UITableView, statsView: StatsViewRendering, codeReportsRepo: ICodeReportsRepository,
         statsFactory: IStatsFactory, cellModelsFactory: IBlockScansCellModelsFactory) {
        self.tableView = tableView
        self.statsView = statsView
        self.codeReportsRepo = codeReportsRepo
        self.statsFactory = statsFactory
        self.cellModelsFactory = cellModelsFactory
        super.init()
        self.hookUpCodeReports()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        blockData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockScansCell", for: indexPath) as! BlockScansCell
                
        let cellModel = blockData[indexPath.row]
        cell.configure(with: cellModel)
        
        return cell
    }
    
    private func hookUpCodeReports() {
        
        self.codeReportsRepo.getObsCodeReports()
            .subscribeOn(MainScheduler.init())
            .subscribe(onNext: { [weak self] reports in
            guard let sSelf = self else {return}
                sSelf.blockData = sSelf.cellModelsFactory.make()
                sSelf.stats = sSelf.statsFactory.make()
            })
            .disposed(by: bag)
    }
    
    private let bag = DisposeBag()
}

