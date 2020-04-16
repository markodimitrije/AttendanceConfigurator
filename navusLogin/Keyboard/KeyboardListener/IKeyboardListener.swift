//
//  IKeyboardListener.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 14/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

protocol IKeyboardListener {
    func getKeyboardEvents() -> Observable<IKeyboardInfo>
}
