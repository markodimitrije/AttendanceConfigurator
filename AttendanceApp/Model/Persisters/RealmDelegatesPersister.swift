//
//  RealmDelegatesPersister.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import Realm
import RxRealm

struct RealmDelegatesPersister {
    
    static var shared = RealmDelegatesPersister()
    
    // MARK:- Fetch (querry) data
    
    func isDelegate(withBarcode code: String, allowedToAttendSessionWithId sessionId: Int) -> Bool {
        guard let realm = try? Realm.init() else {fatalError()}
        let delegate = realm.object(ofType: RealmDelegate.self, forPrimaryKey: code)
        let session = realm.object(ofType: RealmBlock.self, forPrimaryKey: sessionId)
        if session?.chairperson !=  nil { // hard-coded
            return true
        } else {
            // return delegate.sessionIds.contains(sessionId)
            return [1,2,3,4,5].contains(sessionId) // hard-coded
        }
    }
    
    // MARK:- Save data
    
    func save(delegates: [Delegate]) -> Observable<Bool> {
        
        // prvo ih map u svoje objects a onda persist i javi da jesi...
        let realmDelegates = delegates.map { delegate -> RealmDelegate in
            let r = RealmDelegate()
            r.updateWith(delegate: delegate)
            return r
        }
        
        return saveToRealm(objects: realmDelegates)
    }
    
    func saveToRealm<T: Object>(objects: [T]) -> Observable<Bool> {
        
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        
        do {
            try realm.write {
                realm.add(objects)
            }
        } catch {
            return Observable<Bool>.just(false)
        }
        
        return Observable<Bool>.just(true) // all good here
        
    }
    
    // MARK: All data (delete)
    
    func deleteAllDataIfAny() -> Observable<Bool> {
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        return Observable<Bool>.just(true) // all good
    }
    
    func deleteAllObjects<T: Object>(ofTypes types: [T.Type]) -> Observable<Bool> {
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        do {
            try realm.write {
                for type in types {
                    let objects = realm.objects(type)
                    realm.delete(objects)
                }
            }
        } catch {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        return Observable<Bool>.just(true) // all good
    }
    
}
