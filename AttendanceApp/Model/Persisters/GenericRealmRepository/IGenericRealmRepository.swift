//
//  IGenericRealmRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift
import Realm

protocol IGenericRealmRepository {
    func saveToRealm<T: Object>(objects: [T]) -> Observable<Bool>
    func deleteAllObjects<T: Object>(ofTypes types: [T.Type]) -> Observable<Bool>
    func deleteAllDataIfAny() -> Observable<Bool>
}
