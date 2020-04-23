//
//  WebReportedCodesVCFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 23/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class WebReportedCodesVCFactory {
    static func make() -> WebReportedCodesVC {
        let viewController = StoryboardedViewControllerFactory.make(type: WebReportedCodesVC.self) as! WebReportedCodesVC
        return viewController
    }
}
