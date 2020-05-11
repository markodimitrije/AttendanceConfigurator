//
//  IDelegatesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IDelegatesRepository: IDelegatesMutableRepository, IDelegatesImmutableRepository {}

protocol IDelegatesMutableRepository {
    func save(delegates: [IDelegate]) -> Observable<Bool>
    func deleteAllDelegates() -> Observable<Bool>
}

protocol IDelegatesImmutableRepository {
    func delegateHasAccessToBlock(code: String, blockId: Int) -> Bool
}
