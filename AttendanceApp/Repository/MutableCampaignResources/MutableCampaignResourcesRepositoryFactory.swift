//
//  MutableCampaignResourcesRepositoryFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

struct MutableCampaignResourcesRepository {
    let genMutRepo: IGenRealmMutableRepo
    let roomsRepo: IRoomRepository
    let blocksRepo: IBlockMutableRepository
    let delegatesRepo: IDelegatesMutableRepository
}
