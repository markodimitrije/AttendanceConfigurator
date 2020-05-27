//
//  DatesViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class DatesViewControllerFactory {
    static func make() -> DatesViewController {
        
        let datesVC = StoryboardedViewControllerFactory.make(type: DatesViewController.self) as! DatesViewController
        let datesViewModel = DatesViewmodelFactory.make(delegate: datesVC)
        datesVC.datesViewmodel = datesViewModel
        return datesVC
    }
}

class DatesViewmodelFactory {
    static func make(delegate: DatesViewController?) -> DatesViewmodel {
        let blockRepo = BlockImmutableRepositoryFactory.make()
        return DatesViewmodel(delegate: delegate, blockRepo: blockRepo)
    }
}
