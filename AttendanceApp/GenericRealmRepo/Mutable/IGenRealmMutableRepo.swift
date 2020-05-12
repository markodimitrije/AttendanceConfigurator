//
//  IGenRealmMutableRepo.swift
//  GenericsFrm
//
//  Created by Marko Dimitrijevic on 08/05/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RealmSwift

protocol IGenRealmMutableRepo {
    func save<T: Object>(objects: [T]) throws
    func delete<T: Object>(type: T.Type, filter: NSPredicate) throws
}
