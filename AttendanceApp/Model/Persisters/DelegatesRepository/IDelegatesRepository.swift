//
//  IDelegatesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

protocol IDelegatesRepository {
    func save(delegates: [Delegate]) -> Observable<Bool>
    func deleteAllDelegates() -> Observable<Bool>
}
