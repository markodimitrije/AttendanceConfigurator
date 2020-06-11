//
//  IMutableCampaignResourcesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation
import RxSwift

protocol IMutableCampaignResourcesRepository {
    func save(resources: ICampaignResources)
    func obsSave(resources: ICampaignResources) -> Observable<Void>
    func deleteResources()
}

class MutableCampaignResourcesRepositoryFactory {
    static func make() -> IMutableCampaignResourcesRepository {
        return MutableCampaignResourcesRepository(
            genMutRepo: GenRealmMutableRepo(),
            roomsRepo: RoomRepository(),
            blocksRepo: BlockMutableRepositoryFactory.make(),
            delegatesRepo: DelegatesRepositoryFactory.make())
    }
}
