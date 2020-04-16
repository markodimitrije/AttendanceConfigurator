//
//  KeyboardInfo.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 14/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

struct KeyboardInfo: IKeyboardInfo {
    func getInfo() -> (NSNotification.Name, size: CGSize) { (_name, _size) }
    private var _name: NSNotification.Name
    private var _size: CGSize
    init(notification: NSNotification) {
        self._name = notification.name
        self._size = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
    }
}
