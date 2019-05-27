//
//  FetchDelegates.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import Realm
import RxRealm

// MARK:- Fetch (querry) data

class RealmDelegatesSessionValidation {
    
    func isScannedDelegate(withBarcode code: String, allowedToAttendSessionWithId sessionId: Int) -> Bool {
        guard let realm = try? Realm.init() else {fatalError()}
        guard let delegate = realm.object(ofType: RealmDelegate.self, forPrimaryKey: code),
            let session = realm.object(ofType: RealmBlock.self, forPrimaryKey: sessionId) else {
                fatalError()
        }
        if session.tags != "" { // hard-coded
            return true
        } else {
            return delegate.sessionIds.contains(sessionId)
        }
    }
}
