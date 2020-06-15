//
//  LogoutAlertInfoFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 18/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class LogoutAlertInfoFactory {
    static func make() -> AlertInfo {
        let title = AlertInfo.Logout.title
        let text = AlertInfo.Logout.msg
        let yesPresentation = AlertActionPresentation(title: AlertInfo.Common.yesBtn,
                                               style: UIAlertAction.Style.destructive)
        let noPresentation = AlertActionPresentation(title: AlertInfo.Common.noBtn)
        return AlertInfo(title: title, text: text, btnText: [yesPresentation, noPresentation])
    }
}
