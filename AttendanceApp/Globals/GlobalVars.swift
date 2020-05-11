//
//  GlobalVars.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 30/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

let hourMinuteSet = Set<Calendar.Component>.init(arrayLiteral: .hour, .minute)

var defaultAutoSessionDate: Date {
    return Date.init(timeIntervalSinceNow: -MyTimeInterval.waitToMostRecentSession)
}

//var syncResourcesManager: ISyncResourcesManager!

var codesDumper: CodesDumper! // prazni codes (saved in Realm), koji su failed da se prijave pojedinacno na web

//let conferenceId = 7498 // hard-coded!

//let conferenceState = ConferenceApiKeyState()
