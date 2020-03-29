//
//  CodeReport.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 31/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmCodeReport: Object {
    @objc dynamic var code: String = ""
    @objc dynamic var sessionId: Int = 0
    @objc dynamic var date: Date = Date.init(timeIntervalSince1970: 0)
}

class RealmCodeReportFactory {
    
//    static func create(code: String, sessionId: Int, date: Date) -> RealmCodeReport {
//        let object = RealmCodeReport()
//        object.code = code
//        object.sessionId = sessionId
//        object.date = date
//        return object
//    }
    
    static func make(with codeReport: ICodeReport) -> RealmCodeReport {
        let object = RealmCodeReport()
        object.code = codeReport.getCode()
        object.sessionId = codeReport.getSessionId()
        object.date = codeReport.getDate()
        return object
    }
}
