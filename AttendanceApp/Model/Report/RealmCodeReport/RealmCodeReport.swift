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
//    @objc dynamic var id: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var sessionId: Int = 0
    @objc dynamic var date: Date = Date.init(timeIntervalSince1970: 0)
}
