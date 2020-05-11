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
}

extension DelegatesRepository {

    func save(delegates: [IDelegate]) -> Observable<Bool> {
        
        let realmDelegates = delegates.map(RealmDelegateFactory.make)
        return genericRepo.saveToRealm(objects: realmDelegates)
    }
    
    // MARK: All data (delete)
    
    func deleteAllDelegates() -> Observable<Bool> {
        return self.genericRepo.deleteAllObjects(ofTypes: [RealmDelegate.self])
    }
    
}

extension DelegatesRepository {
    func delegateHasAccessToBlock(code: String, blockId: Int) -> Bool {
        guard code.count >= 6 else {
            return false // hard-coded, odbij ga da nema pravo, a hostese neka ga puste da udje....
        }

        let trimedToSixCharCode = trimmedToSixCharactersCode(code: code)
        guard let realm = try? Realm.init(),
            let delegate = realm.object(ofType: RealmDelegate.self, forPrimaryKey: trimedToSixCharCode) else {
                return false
        }
        return delegate.blockIds.contains(blockId)
    }
}
