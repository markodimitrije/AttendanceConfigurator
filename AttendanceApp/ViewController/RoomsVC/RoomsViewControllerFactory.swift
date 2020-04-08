//
//  RoomsViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class RoomsViewControllerFactory {
    static func make() -> RoomsVC {
        let sb = MainStoryboardFactory.make()
        let roomsVC = sb.instantiateViewController(withIdentifier: "RoomsVC") as! RoomsVC
        roomsVC.roomViewModel = RoomsViewModelFactory.make()
        return roomsVC
    }
}
