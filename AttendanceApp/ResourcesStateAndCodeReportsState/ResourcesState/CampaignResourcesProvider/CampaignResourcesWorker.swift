//
//  CampaignResourcesWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignResourcesWorker: ICampaignResourcesWorker {
    func work() -> Observable<Void> {
        resourcesApiController.fetch()
            .do(onNext: { (resources) in
                print("CampaignResourcesWorker.work PERSIST resources")
                self.roomsRepo.save(rooms: resources.getLocations())
                self.blocksRepo.save(blocks: resources.getSessions())
                self.delegatesRepo.save(delegates: resources.getDelegates())
            }).map {_ in return ()}
    }
}

struct CampaignResourcesWorker {
    var resourcesApiController: ICampaignResourcesApiController
    var roomsRepo: IRoomRepository
    var blocksRepo: IBlockMutableRepository
    var delegatesRepo: IDelegatesRepository
}
