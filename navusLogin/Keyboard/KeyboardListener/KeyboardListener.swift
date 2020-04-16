//
//  KeyboardListener.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 14/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
//import UIKit

class KeyboardListener: IKeyboardListener {
    
    func getKeyboardEvents() -> Observable<IKeyboardInfo> {
        return _keyboardEvents.map {$0 as IKeyboardInfo}.asObservable()
    }
    
    private let _keyboardEvents = PublishSubject<KeyboardInfo>()
    
    init() {
        NotificationCenter.default
            .addObserver( self, selector: #selector(KeyboardListener.keyboardChange(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(KeyboardListener.keyboardChange(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardChange(_ notification: NSNotification) {
        let keyboardInfo = KeyboardInfo(notification: notification)
        _keyboardEvents.onNext(keyboardInfo)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
    }
    
}
