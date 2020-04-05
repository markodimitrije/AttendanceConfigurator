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

class RealmInvalidAttedanceReportPersister {
    
    var genericRepo: IGenericRealmRepository
    
    init(genericRepo: IGenericRealmRepository) {
        self.genericRepo = genericRepo
    }

    func saveToRealm(invalidAttendanceCode code: String) -> Observable<Bool> {
        
        let newReport = RealmInvalidAttendanceReport.create(code: code,
                                                            date: Date.now,
                                                            dataAccess: DataAccess.shared)
        
        return self.genericRepo.saveToRealm(objects: [newReport])
        
    }
}

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
