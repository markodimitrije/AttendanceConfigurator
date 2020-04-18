//
//  AlertActionPresentation.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 18/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

struct AlertActionPresentation: IAlertActionPresentation {
    var title: String
    var style: UIAlertAction.Style
    init(title: String, style: UIAlertAction.Style = .default) {
        self.title = title
        self.style = style
    }
}
