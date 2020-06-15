//
//  AlertInfo.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 17/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

struct AlertInfo {
    static let ok = NSLocalizedString("Strings.Alert.ok", comment: "")
    var title: String?
    var text: String?
    var btnText = [IAlertActionPresentation]()
    
    struct Scan {
        struct ScanningNotSupported { // device
            static let title = NSLocalizedString("Strings.Scan.ScanningNotSupported.title", comment: "")
            static let msg = NSLocalizedString("Strings.Scan.ScanningNotSupported.msg", comment: "")
        }
        struct NoSettings { //
            static let title = NSLocalizedString("Strings.Scan.NoSettings.title", comment: "")
            static let msg = NSLocalizedString("Strings.Scan.NoSettings.msg", comment: "")
        }
        struct ScanSettingsMissing { //
            static let title = NSLocalizedString("scanner.popUp.noSettings.title", comment: "")
            static let msg = NSLocalizedString("scanner.popUp.noSettings.msg", comment: "")
        }
    }
    
    struct Logout { // device
        static let title = NSLocalizedString("logout.title", comment: "")
        static let msg = NSLocalizedString("logout.text", comment: "")
    }
    
    struct Common {
        static let yesBtn = NSLocalizedString("common.yes", comment: "")
        static let noBtn = NSLocalizedString("common.no", comment: "")
        static let okBtn = NSLocalizedString("common.ok", comment: "")
    }
}
