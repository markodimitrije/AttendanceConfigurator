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
    
//    private var data = [CodeReportCellModel]() {
//        didSet {
//            self.tableView.reloadData()
//        }
//    } // hooked with realm in func: "hookUpDataFromRealm"
    
    private var blockData = [IBlockStatsTableViewCellModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let tableView: UITableView
    private let statsView: StatsViewRendering
    private let repository: ICodeReportsRepository
    private let blockRepo = BlockImmutableRepository()
    private let roomRepo = RoomRepository()
    
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
        blockData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsViewCell", for: indexPath) as! StatsViewCell
                
        let cellModel = blockData[indexPath.row]
        cell.configure(with: cellModel)
        
        return cell
    }
    
    private func hookUpCodeReports() {
        
        self.repository.getObsCodeReports()
            .subscribeOn(MainScheduler.init())
            .subscribe(onNext: { [weak self] reports in
            guard let sSelf = self else {return}
                //sSelf.data = reports.map(CodeReportCellModelFactory.make)
                sSelf.blockData = BlockStatsCellModelsFactory.make(codeRepo: sSelf.repository, roomRepo: sSelf.roomRepo, blockRepo: sSelf.blockRepo)
                sSelf.stats = StatsFactory.make(repository: sSelf.repository)
            })
            .disposed(by: bag)
    }
    
    private let bag = DisposeBag()
}

struct StatsFactory {
    static func make(repository: ICodeReportsRepository) -> StatsProtocol {
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

struct BlockStatsCellModelsFactory {
    static func make(codeRepo: ICodeReportsRepository,
                     roomRepo: IRoomRepository,
                     blockRepo: IBlockImmutableRepository) -> [IBlockStatsTableViewCellModel] {
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
