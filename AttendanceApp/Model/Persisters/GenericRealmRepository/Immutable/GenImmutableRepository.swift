//
//  GenImmutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift
import RxSwift

// Realm Immutable

extension IGenImmutableRepo {
    
    func getObjects<T: Object>(ofType type: T.Type,
                               filter: NSPredicate = NSPredicate(format: "TRUEPREDICATE"),
                               sortDescriptors: [SortDescriptor] = [ ]) throws -> Array<T> {
        
        try getResults(ofType: type, filter: filter, sortDescriptors: sortDescriptors)
            .toArray()
    }

    func getObsObjects<T: Object>(ofType type: T.Type,
                                  filter: NSPredicate = NSPredicate(format: "TRUEPREDICATE"),
                                  sortDescriptors: [SortDescriptor] = [ ]) -> Observable<Array<T>> {
        
        do {
            let results = try getResults(ofType: type, filter: filter, sortDescriptors: sortDescriptors)
            return Observable.collection(from: results).map {$0.toArray()}
        } catch let err {
            return ErrorObservableFactory.make(type: Array<T>.self, err: err)
        }
        
    }
    
    func getResults<T: Object>(ofType type: T.Type,
                               filter: NSPredicate,
                               sortDescriptors: [SortDescriptor]) throws -> Results<T> {
        do {
            let realm = try Realm()
            return realm.objects(type).filter(filter).sorted(by: sortDescriptors)
        } catch let err {
            throw err
        }
    }
    
}
