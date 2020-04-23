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
        let blockRepo = BlockImmutableRepositoryFactory.make()
        datesVC.datesViewmodel = DatesViewmodel(blockRepo: blockRepo)
        return datesVC
    }
}
