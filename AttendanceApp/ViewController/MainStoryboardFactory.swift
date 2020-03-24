//
//  MainStoryboardFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class MainStoryboardFactory {
    static func make() -> UIStoryboard {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        return sb
    }
    
}
