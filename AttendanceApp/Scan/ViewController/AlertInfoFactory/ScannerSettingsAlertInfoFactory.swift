//
//  ScannerSettingsAlertInfoFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 23/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class ScannerSettingsAlertInfoFactory {
    static func make() -> AlertInfo {
        let title = AlertInfo.Scan.NoSettings.title
        let text = AlertInfo.Scan.NoSettings.msg
        let yesPresentation = AlertActionPresentation(title: AlertInfo.Logout.yesBtn)
        return AlertInfo(title: title, text: text, btnText: [yesPresentation])
    }
}
