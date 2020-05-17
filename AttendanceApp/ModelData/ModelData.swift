//
//  ModelData.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 22/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit

enum SessionTextData {
    static let sessionConst = NSLocalizedString("Strings.Scaner.block.SessionConst", comment: "")
    static let noActiveSession = NSLocalizedString("Strings.Scaner.block.noActiveSession", comment: "")
    static let noActiveSessionForRoom = NSLocalizedString("Strings.Scaner.block.noActiveSessionForRoom", comment: "")
    static let selectSession = NSLocalizedString("Strings.Scaner.block.selectSession", comment: "")
    static let noAutoSelSessionsAvailable = NSLocalizedString("Strings.Scaner.block.noAutoSelSessionsAvailable", comment: "")
    static let selectSessManuallyOrTryAuto = NSLocalizedString("Strings.Scaner.block.selSessionManuallyOrTryAuto", comment: "")
    static let noAutoSessAvailable = NSLocalizedString("Strings.Scaner.block.noAutoSessionAvailable", comment: "")
    static let selectSessionManually = NSLocalizedString("Strings.Scaner.block.selSessionManually", comment: "")
    
}

enum RoomTextData {
    static let selectRoom = NSLocalizedString("Strings.Scaner.room.SelectRoom", comment: "")
    static let noRoomSelected = NSLocalizedString("Strings.Scaner.room.noRoomSelected", comment: "")
}

struct MyTimeInterval {
    static let waitToMostRecentBlock: TimeInterval = 15//15*60//1*60// // 15 seconds
    static let timerForFetchingRoomBlockDelegateResources: Double = 15*60//27 // 10 seconds
    static let timeoutForFetchingRoomAndBlockResources = 30 // 10 seconds
    static let sendScanReportsToWebEvery: Double = 10*60 // 8 seconds
}

struct MyConstants {
    static let batteryLevelTrig: Int = 30 // percent
}

extension UserDefaults {
    static let keyResourcesDownloaded = "resourcesDownloaded"
    
    static let keyConferenceApiKey = "keyConferenceApiKey"
    static let keyConferenceId = "keyConferenceId"
    static let keyConferenceAuth = "keyConferenceAuth"
}

extension String {
    static let now = Date.init(timeIntervalSinceNow: 0).toString(format: Date.defaultFormatString) ?? ""
}

let batteryStateConverter: [UIDevice.BatteryState: String] = [
    .charging: "charging",
    .unknown: "unknown",
    .full: "full",
    .unplugged: "unplugged"
]

struct Constants {
    static let syncApiKey = "Sync API Key"
    static let sync = "Sync"
}
