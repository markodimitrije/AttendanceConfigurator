//
//  RealmViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 20/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import RxSwift
import RxRealm

class RoomViewModel {
    
    private let disposeBag = DisposeBag()
    
    private(set) var rooms: Results<RealmRoom>!
    
    init() {
        bindOutput()
    }
    
    // input
    var selectedTableIndex: BehaviorSubject<Int?> = BehaviorSubject.init(value: nil)
    
    // output
    
    private(set) var oRooms: Observable<(AnyRealmCollection<RealmRoom>, RealmChangeset?)>!
    
    private(set) var selectedRoom = BehaviorSubject<RealmRoom?>.init(value: nil)
    
    // MARK:- calculators
    
    func getRoom(forSelectedTableIndex index: Int) -> Room {
        
        return RoomFactory.make(from: rooms[index]) as! Room
    }
    
    // MARK:- Private methods
    
    private func bindOutput() { // hook-up se za Realm, sada su Rooms synced sa bazom
        
        guard let realm = try? Realm() else { return }
        
        rooms = realm.objects(RealmRoom.self)
        
        oRooms = Observable.changeset(from: rooms)

    }

}
