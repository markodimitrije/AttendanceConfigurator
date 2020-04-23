//
//  RoomsViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class RoomsViewControllerFactory {
    static func make() -> RoomsViewController {
        let roomsVC = StoryboardedViewControllerFactory.make(type: RoomsViewController.self) as! RoomsViewController
        roomsVC.roomViewModel = RoomsViewModelFactory.make()
        return roomsVC
    }
}
