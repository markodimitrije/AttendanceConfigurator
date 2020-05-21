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

extension IGenRealmMutableRepo {
    func save<T: Object>(objects: [T]) throws {
        let realm = try Realm()
        try writeTo(realm: realm) {
            realm.add(objects, update: .modified)
        }
    }
    
    func delete<T: Object>(type: T.Type, filter: NSPredicate = NSPredicate.truePredicate) throws {
        let realm = try Realm()
        let results = realm.objects(type).filter(filter)
        try realm.write {
            realm.delete(results)
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

