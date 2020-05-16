//
//  CampaignStatsDataSourceFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

// TODO marko:
// 1. CampaignSelection da nije optional
// 2. dont set to NIL if user comes back to campaigns live selection, it will updated on next iPath
// 3. on selected check if previous is the same? if so, dont delete campaign settings

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

