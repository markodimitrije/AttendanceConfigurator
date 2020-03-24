//
//  DatesViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class DatesViewControllerFactory {
    static func make() -> DatesVC {
        let sb = MainStoryboardFactory.make()
        let datesVC = sb.instantiateViewController(withIdentifier: "DatesVC") as! DatesVC
        let blockViewmodel = BlockViewModel()
        datesVC.datesViewmodel = DatesViewmodel.init(blockViewmodel: blockViewmodel)
        return datesVC
    }
}
