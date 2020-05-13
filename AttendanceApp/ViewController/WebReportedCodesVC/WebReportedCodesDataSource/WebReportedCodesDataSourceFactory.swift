//
//  WebReportedCodesDataSourceFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class WebReportedCodesDataSourceFactory {
    static func make(tableView: UITableView, statsView: StatsViewRendering) -> WebReportedCodesDataSource {
        let codeReportsRepo = CodeReportsRepositoryFactory.make()
        let statsFactory = StatsFactory(repository: codeReportsRepo)
        let cellModelsFactory = BlockStatsCellModelsFactory(codeRepo: codeReportsRepo,
                                                            roomRepo: RoomRepository(),
                                                            blockRepo: BlockImmutableRepository())
        return WebReportedCodesDataSource(tableView: tableView, statsView: statsView, codeReportsRepo: codeReportsRepo, statsFactory: statsFactory, cellModelsFactory: cellModelsFactory)
    }
}
