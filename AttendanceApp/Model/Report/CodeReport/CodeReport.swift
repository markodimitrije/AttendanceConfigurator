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
    func getBlockId() -> Int { self.blockId }
    func getDate() -> Date { self.date }
    func isReported() -> Bool {self.reported}
    func isAccepted() -> Bool {self.accepted}
}

struct CodeReport {
    
    private let code: String
    private let blockId: Int
    private var date: Date = Date(timeIntervalSinceNow: 0)
    var reported = false
    private let accepted: Bool
    
    init(code: String, blockId: Int, date: Date, accepted: Bool) {
        self.code = code
        self.blockId = blockId
        self.date = date
        self.accepted = accepted
    }
    
    init(realmCodeReport: RealmCodeReport) {
        self.code = realmCodeReport.code
        self.blockId = realmCodeReport.blockId
        self.date = realmCodeReport.date
        self.reported = realmCodeReport.reported
        self.accepted = realmCodeReport.accepted
    }
    
}
