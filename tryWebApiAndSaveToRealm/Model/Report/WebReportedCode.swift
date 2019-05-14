//
//  WebReportedCode.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 14/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class WebReportedCode {
    
}

class RealmWebReportedCode: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var code: String = ""
    @objc dynamic var date: Date?
    
    static func create(id: Int, codeReport: CodeReport) -> RealmWebReportedCode {
        let object = RealmWebReportedCode()
        object.id = id
        object.code = codeReport.code
        object.date = codeReport.date
        return object
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
