//
//  LoginKeyboardHandler.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 14/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LoginKeyboardHandler: IKeyboardHandler {
    
    func handleKeyboardEvent(info: IKeyboardInfo) {
        if info.getInfo().0 == UIApplication.keyboardWillShowNotification {
            if self.centerYcnstr.constant == 0 {
                self.centerYcnstr.constant -= info.getInfo().size.height/2
            }
        } else if info.getInfo().0 == UIApplication.keyboardWillHideNotification {
            self.centerYcnstr.constant = 0
        }
    }
    private let centerYcnstr: NSLayoutConstraint
    init(centerYcnstr: NSLayoutConstraint) {
        self.centerYcnstr = centerYcnstr
    }
}
