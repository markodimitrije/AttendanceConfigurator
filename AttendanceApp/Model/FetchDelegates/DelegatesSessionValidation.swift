//
//  DelegatesSessionValidation.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import RealmSwift

// MARK:- Fetch (querry) data

protocol IDelegatesSessionValidation {
    func isScannedDelegate(withBarcode code: String, sessionId: Int) -> Bool
}

extension DelegatesSessionValidation: IDelegatesSessionValidation {
    func isScannedDelegate(withBarcode code: String, sessionId: Int) -> Bool {
        
        if isClosedSession(sessionId: sessionId) == false { // free session
            return true
        } else {
            return delegateHasAccessToSession(code: code, sessionId: sessionId)
        }
    }
}

class DelegatesSessionValidation {
    private let blockRepo: IBlockImmutableRepository
    private let delegateRepo: IDelegatesImmutableRepository
    init(blockRepo: IBlockImmutableRepository, delegateRepo: IDelegatesImmutableRepository) {
        self.blockRepo = blockRepo
        self.delegateRepo = delegateRepo
    }
    
    private func isClosedSession(sessionId: Int) -> Bool {
        
        guard let session = blockRepo.getBlock(id: sessionId) else {
            return false
        }
        return session.getClosed()
    }
    
    private func delegateHasAccessToSession(code: String, sessionId: Int) -> Bool {
        delegateRepo.delegateHasAccessToSession(code: code, sessionId: sessionId)
    }
    
}
