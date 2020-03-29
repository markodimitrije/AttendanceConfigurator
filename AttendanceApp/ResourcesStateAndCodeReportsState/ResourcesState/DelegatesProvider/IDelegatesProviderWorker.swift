//
//  IDelegatesProviderWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IDelegatesProviderWorker {
    func fetchDelegatesAndPersistOnDevice() -> Observable<([Delegate])>
}


