//
//  GenRealmMutableRepo.swift
//  GenericsFrm
//
//  Created by Marko Dimitrijevic on 08/05/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RealmSwift

extension GenRealmMutableRepo: IGenRealmMutableRepo {
    
    func save<T: Object>(objects: [T]) throws {
        let realm = try Realm()
        try writeTo(realm: realm) {
            realm.add(objects, update: .modified)
        }
    }
    func delete<T: Object>(type: T.Type, filter: NSPredicate) throws {
        do {
            let results = try genericImmutableRepo.getObjects(ofType: type, filter: filter, sortDescriptors: [])
            try self.delete(results: results)
        } catch let err {
            throw err
        }
    }
    
    private func delete<T: Object>(results: Results<T>) throws {
        let realm = try Realm()
        try writeTo(realm: realm) {
            realm.delete(results)
        }
    }
    
    private func writeTo(realm: Realm, closure: () -> ()) throws {
        do {
            try realm.write {
                closure()
            }
        } catch let err {
            throw err
        }
    }
}

class GenRealmMutableRepo {
    private let genericImmutableRepo: IGenRealmImmutableRepo
    init(genericImmutableRepo: IGenRealmImmutableRepo = GenRealmImmutableRepo()) {
        self.genericImmutableRepo = genericImmutableRepo
    }
}
