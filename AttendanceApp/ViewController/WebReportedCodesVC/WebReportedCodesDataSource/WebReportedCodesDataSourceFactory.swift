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
        let repository = CodeReportsRepositoryFactory.make()
        return WebReportedCodesDataSource(tableView: tableView, statsView: statsView, repository: repository)
    }
}
