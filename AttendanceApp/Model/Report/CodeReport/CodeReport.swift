//
//  CodeReport.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 18/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation

extension CodeReport: ICodeReport {
    func getCode() -> String { self.code }
    func getSessionId() -> Int { self.sessionId }
    func getDate() -> Date { self.date }
    func isReported() -> Bool {self.reported}
    func isAccepted() -> Bool {self.accepted}
}

struct CodeReport {
    
    private let code: String
    private let sessionId: Int
    private var date: Date = Date(timeIntervalSinceNow: 0)
    var reported = false
    private let accepted: Bool
    
    init(code: String, sessionId: Int, date: Date, accepted: Bool) {
        self.code = code
        self.sessionId = sessionId
        self.date = date
        self.accepted = accepted
    }
    
    init(realmCodeReport: RealmCodeReport) {
        self.code = realmCodeReport.code
        self.sessionId = realmCodeReport.sessionId
        self.date = realmCodeReport.date
        self.reported = realmCodeReport.reported
        self.accepted = realmCodeReport.accepted
    }
    
}
