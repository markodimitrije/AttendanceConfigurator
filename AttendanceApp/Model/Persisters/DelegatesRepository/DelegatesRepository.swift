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
        
        // prvo ih map u svoje objects a onda persist i javi da jesi...
        let realmDelegates = delegates.map { delegate -> RealmDelegate in
            let r = RealmDelegate()
            r.updateWith(delegate: delegate)
            return r
        }
        
        return genericRepo.saveToRealm(objects: realmDelegates)//saveToRealm(objects: realmDelegates)
    }
    
    // MARK: All data (delete)
    
    func deleteAllObjects<T: Object>(ofTypes types: [T.Type]) -> Observable<Bool> {
        return self.genericRepo.deleteAllObjects(ofTypes: types)
    }
    
}
