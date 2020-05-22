//
//  ScanSettingsFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class ScanSettingsFactory {
    static func make(scanSettings: IScanSettings) -> RealmScanSettings {
        let object = RealmScanSettings()
        let roomId = (scanSettings.roomId != nil) ? "\(scanSettings.roomId!)" : nil
        let blockId = (scanSettings.blockId != nil) ? "\(scanSettings.blockId!)" : nil
        object.roomId = roomId
        object.blockId = blockId
        object.date = scanSettings.selectedDate
        object.autoSwitch = scanSettings.autoSwitch
        
        return object
    }
    
    static func make(rScanSettings: RealmScanSettings) -> IScanSettings {
        let roomId = (rScanSettings.roomId != nil) ? Int(rScanSettings.roomId!) : nil
        let blockId = (rScanSettings.blockId != nil) ? Int(rScanSettings.blockId!) : nil
        return ScanSettings(roomId: roomId,
                            blockId: blockId,
                            selDate: rScanSettings.date,
                            autoSwitch: rScanSettings.autoSwitch)
    }
}
