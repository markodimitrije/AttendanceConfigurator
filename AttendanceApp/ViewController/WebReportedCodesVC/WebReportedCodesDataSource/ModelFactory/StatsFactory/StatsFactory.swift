//
//  StatsFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 13/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

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
