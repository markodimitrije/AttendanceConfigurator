//
//  RealmInvalidAttedanceReportPersister.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 11/06/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import Realm
import RxRealm

class RealmObjectPersister {
    func saveToRealm<T: Object>(objects: [T]) -> Observable<Bool> {
        
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        
        do {
            try realm.write {
                //realm.add(objects)
                realm.add(objects, update: true)
            }
        } catch {
            return Observable<Bool>.just(false)
        }
        
        return Observable<Bool>.just(true) // all good here
        
    }
}

class RealmInvalidAttedanceReportPersister {
    
    var realmObjectPersister: RealmObjectPersister
    
    init(realmObjectPersister: RealmObjectPersister) {
        self.realmObjectPersister = realmObjectPersister
    }

    func saveToRealm(invalidAttendanceCode code: String) -> Observable<Bool> {
        
        let newReport = RealmInvalidAttendanceReport.create(code: code,
                                                            date: Date.now,
                                                            dataAccess: DataAccess.shared)
        
        return realmObjectPersister.saveToRealm(objects: [newReport])
        
    }
}

import Foundation
import Realm
import RealmSwift

class RealmInvalidAttendanceReport: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var sessionId: Int = 0
    @objc dynamic var roomId: Int = 0
    @objc dynamic var date: Date?
    
    static func create(code: String, date: Date?, dataAccess: DataAccess) -> RealmInvalidAttendanceReport {
        let object = RealmInvalidAttendanceReport()
        object.code = code
        object.sessionId = dataAccess.userSelection.blockId ?? 0
        object.roomId = dataAccess.userSelection.roomId ?? 0
        object.date = date
        
        object.id = code + "\(object.roomId)" + "\(object.sessionId)"
        
        return object
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
