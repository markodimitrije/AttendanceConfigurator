//
//  DelegatesProviderWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

class DelegateProviderWorker: IDelegateProviderWorker {
    // inject unziper..
    private let bag = DisposeBag()
    private let apiController: DelegatesAPIController
    private let repository: RealmDelegatesPersister

    init(apiController: DelegatesAPIController, repository: RealmDelegatesPersister) {
        self.apiController = apiController
        self.repository = repository
    }
    
    func fetchDelegatesAndPersistOnDevice() -> Observable<Bool> {
        
        let oNewDelegates = apiController.getDelegates()
        
        let oOldDeleted = RealmDelegatesPersister.shared
            .deleteAllObjects(ofTypes: [RealmDelegate.self])
            .filter {$0}
        
        let result = Observable.combineLatest(oNewDelegates, oOldDeleted) { (delegates, success) -> [Delegate] in
            return success ? delegates : [ ]
        }
        
        return result.flatMap(RealmDelegatesPersister.shared.save)
    }
    
}
