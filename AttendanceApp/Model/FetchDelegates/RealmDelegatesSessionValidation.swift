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
        
        if isClosedSession(sessionId: sessionId) == false { // free session
            return true
        } else {
            return delegateHasAccessToSession(code: code, allowedToAttendSessionWithId: sessionId)
        }
    }
    
    private func isClosedSession(sessionId: Int) -> Bool {
        guard let realm = try? Realm.init(),
            let session = realm.object(ofType: RealmBlock.self, forPrimaryKey: sessionId) else {
                return false // fall back, realno je fatalError....
        }
        return session.closed
    }
    
    private func delegateHasAccessToSession(code: String, allowedToAttendSessionWithId sessionId: Int) -> Bool {
        let trimedToSixCharCode = trimmedToSixCharactersCode(code: code)
        guard let realm = try? Realm.init(),
            let delegate = realm.object(ofType: RealmDelegate.self, forPrimaryKey: trimedToSixCharCode) else {
                return false
        }
        return delegate.sessionIds.contains(sessionId)
    }
    
}
