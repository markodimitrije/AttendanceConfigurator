//
//  DelegatesRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import RxSwift
import RealmSwift
import Realm

struct DelegatesRepository: IDelegatesRepository {
    
    private let genericRepo: IGenericRealmRepository
    
    init(genericRepo: IGenericRealmRepository) {
        self.genericRepo = genericRepo
    }
    
    func save(delegates: [Delegate]) -> Observable<Bool> {
        
        let realmDelegates = delegates.map(RealmDelegateFactory.make)
        return genericRepo.saveToRealm(objects: realmDelegates)
    }
    
    // MARK: All data (delete)
    
    func deleteAllDelegates() -> Observable<Bool> {
        return self.genericRepo.deleteAllObjects(ofTypes: [RealmDelegate.self])
    }
    
}
