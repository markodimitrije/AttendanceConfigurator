//
//  CampaignResourcesWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignResourcesWorker: ICampaignResourcesWorker {
    func work() -> Observable<Void> { // hard-coded
        return Observable.create { (observer) -> Disposable in
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

struct CampaignResourcesWorker {
    var resourcesApiController: ICampaignResourcesApiController
    var roomsRepo: IRoomRepository
    var blocksRepo: IBlockMutableRepository
    var delegatesRepo: IDelegatesRepository
}
