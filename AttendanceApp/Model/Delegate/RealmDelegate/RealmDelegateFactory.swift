//
//  RealmDelegateFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class RealmDelegateFactory {
    static func make(delegate: IDelegate) -> RealmDelegate {
        let rDelegate = RealmDelegate()
        rDelegate.updateWith(delegate: delegate)
        return rDelegate
    }
}
