//
//  IAlertActionPresentation.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 18/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol IAlertActionPresentation {
    var title: String {get}
    var style: UIAlertAction.Style {get}
}
