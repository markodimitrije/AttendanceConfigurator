//
//  DelegatesProviderWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

class DelegatesProviderWorker: IDelegatesProviderWorker {
    // inject unziper..
    init() {
        
    }
    
    func fetchDelegatesAndPersistOnDevice() -> Observable<([Delegate])> {
        return DelegatesAPIController.shared.getDelegates()
    }
    
}
