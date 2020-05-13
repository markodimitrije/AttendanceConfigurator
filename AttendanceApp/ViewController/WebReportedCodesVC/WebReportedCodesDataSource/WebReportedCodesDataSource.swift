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
    private let cellModelsFactory: IBlockStatsCellModelsFactory
    
    init(tableView: UITableView, statsView: StatsViewRendering, codeReportsRepo: ICodeReportsRepository,
         statsFactory: IStatsFactory, cellModelsFactory: IBlockStatsCellModelsFactory) {
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

        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsViewCell", for: indexPath) as! StatsViewCell
                
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

protocol IStatsFactory {
    func make() -> StatsProtocol
}

struct StatsFactory: IStatsFactory {
    let repository: ICodeReportsRepository
    func make() -> StatsProtocol {
        let total = repository.getTotalScansCount(blockId: nil)
        let approved = repository.getApprovedScansCount()
        let rejected = repository.getRejectedScansCount()
        let synced = repository.getSyncedScansCount()
        
        return Stats(totalTitle: NSLocalizedString("total.title", comment: ""),
                     totalValue: "\(total)",
                    approvedTitle: NSLocalizedString("approved.title", comment: ""),
                    approvedValue: "\(approved)" + "/" + "\(total)",
                    rejectedTitle: NSLocalizedString("rejected.title", comment: ""),
                    rejectedValue: "\(rejected)" + "/" + "\(total)",
                    syncedTitle: NSLocalizedString("synced.title", comment: ""),
                    syncedValue: "\(synced)" + "/" + "\(total)")
    }
}

protocol IBlockStatsCellModelsFactory {
    func make() -> [IBlockStatsTableViewCellModel]
}

struct BlockStatsCellModelsFactory: IBlockStatsCellModelsFactory {
    let codeRepo: ICodeReportsRepository
    let roomRepo: IRoomRepository
    let blockRepo: IBlockImmutableRepository
    
    func make() -> [IBlockStatsTableViewCellModel] {
        let blocks = blockRepo.getBlocks()
        let scans = blocks.map { codeRepo.getTotalScansCount(blockId: $0.getId()) }.sorted(by: >)
        let cellModels = scans.enumerated().map { (index, scans) -> BlockStatsTableViewCellModel in
            let block = blocks[index]
            let roomName = roomRepo.getRoom(id: block.getLocationId())?.getName() ?? ""
            return BlockStatsTableViewCellModel(date: block.getStartsAt(),
                                                room: roomName,
                                                title: block.getName(),
                                                count: "Scans: \(scans)")
        }
        return cellModels
    }
}

