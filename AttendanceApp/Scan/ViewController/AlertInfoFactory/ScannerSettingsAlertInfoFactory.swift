//
//  ScannerSettingsAlertInfoFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 23/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class ScannerSettingsAlertInfoFactory {
    func make(alertType: ScannerAlertType) -> AlertInfo {
        switch alertType {
        case .noSettings:
            let title = AlertInfo.Scan.NoSettings.title
            let text = AlertInfo.Scan.NoSettings.msg
            let okPresentation = AlertActionPresentation(title: AlertInfo.Common.okBtn)
            return AlertInfo(title: title, text: text, btnText: [okPresentation])
        case .scanSettingMissing:
            let title = AlertInfo.Scan.ScanSettingsMissing.title
            let text = AlertInfo.Scan.ScanSettingsMissing.msg
            let noPresentation = AlertActionPresentation(title: AlertInfo.Common.noBtn)
            let yesPresentation = AlertActionPresentation(title: AlertInfo.Common.yesBtn)
            return AlertInfo(title: title, text: text, btnText: [yesPresentation, noPresentation])
        }
    }
}

enum ScannerAlertType {
    case scanSettingMissing
    case noSettings
}

