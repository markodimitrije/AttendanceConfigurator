//
//  GenRealmImmutableRepo.swift
//  GenericsFrm
//
//  Created by Marko Dimitrijevic on 08/05/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RealmSwift
import RxRealm

class GenRealmImmutableRepo: IGenRealmImmutableRepo {
    
    func getObjects<T: Object>(ofType type: T.Type,
                               filter: NSPredicate = NSPredicate(format: "TRUEPREDICATE"),
                               sortDescriptors: [SortDescriptor] = [ ]) throws -> Results<T> {
        
        do {
            let realm = try Realm()
            return realm.objects(type).filter(filter).sorted(by: sortDescriptors)
        } catch let err {
            throw err
        }
    }

    func getObsObjects<T: Object>(ofType type: T.Type,
                                  filter: NSPredicate = NSPredicate(format: "TRUEPREDICATE"),
                                  sortDescriptors: [SortDescriptor] = [ ]) -> Observable<Results<T>> {
        do {
            let results = try self.getObjects(ofType: type, filter: filter, sortDescriptors: sortDescriptors)
            return Observable.collection(from: results)
        } catch let err {
            return ErrorObservableFactory.make(type: Results<T>.self, err: err)
        }
    }
}

class ErrorObservableFactory {
    static func make<T>(type: T.Type, err: Error) -> Observable<T> {
        return Observable.create { (observer) -> Disposable in
            observer.onError(err)
            return Disposables.create()
        }
    }
}
