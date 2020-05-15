//
//  CodeReportsRepositoryFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class CodeReportsRepositoryFactory {
    static func make() -> ICodeReportsRepository {
        let campaignId = CampaignSelectionRepositoryFactory.make().getSelected()!.getCampaignId()
        let readRepo = CodeReportsImmutableRepository(campaignId: campaignId)
        let writeRepo = CodeReportsMutableRepository(genericRepo: GenericRealmRepository())
        return CodeReportsRepository(readRepo: readRepo,
                                     writeRepo: writeRepo)
    }
}
