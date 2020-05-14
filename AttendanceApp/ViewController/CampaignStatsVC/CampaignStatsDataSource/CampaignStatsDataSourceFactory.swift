//
//  CampaignStatsDataSourceFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class CampaignStatsDataSourceFactory {
    static func make(tableView: UITableView, statsView: StatsViewRendering) -> CampaignStatsDataSource {
        let codeReportsRepo = CodeReportsRepositoryFactory.make()
        let statsFactory = StatsFactory(repository: codeReportsRepo)
        let cellModelsFactory = BlockScansCellModelsFactory(codeRepo: codeReportsRepo,
                                                            roomRepo: RoomRepository(),
                                                            blockRepo: BlockImmutableRepository())
        return CampaignStatsDataSource(tableView: tableView, statsView: statsView, codeReportsRepo: codeReportsRepo, statsFactory: statsFactory, cellModelsFactory: cellModelsFactory)
    }
}

