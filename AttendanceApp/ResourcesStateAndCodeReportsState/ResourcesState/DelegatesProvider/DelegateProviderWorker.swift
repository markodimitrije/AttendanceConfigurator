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
    private let repository: IDelegatesMutableRepository

    init(apiController: DelegatesAPIController, repository: IDelegatesMutableRepository) {
        self.apiController = apiController
        self.repository = repository
    }
    
    func fetchDelegatesAndPersistOnDevice() -> Observable<Bool> {
        
        let oNewDelegates = apiController.getDelegates()
        
        let oOldDeleted = self.repository.deleteAllDelegates().filter {$0}
        
        let result = Observable.combineLatest(oNewDelegates, oOldDeleted) { (delegates, success) -> [Delegate] in
            return success ? delegates : [ ]
        }
        
        return result.flatMap(self.repository.save)
    }
    
}
