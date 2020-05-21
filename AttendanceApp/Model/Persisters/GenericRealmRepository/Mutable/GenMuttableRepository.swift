//
//  GenMuttableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift
import Realm

class GenMuttableRepository: IGenMuttableRepository {
    
    func saveToRealm<T: Object>(objects: [T]) -> Observable<Bool> {
        
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        
        do {
            try realm.write {
                realm.add(objects, update: .modified)
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
    
    func delete<T: Object>(objects: [T]) -> Observable<Void> {
        guard let realm = try? Realm() else {
            return Observable<Void>.empty()
        }
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            return Observable<Void>.empty()
        }
        return Observable<Void>.just(())
    }
    
}

