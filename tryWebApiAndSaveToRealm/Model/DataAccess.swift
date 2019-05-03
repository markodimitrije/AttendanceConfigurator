//
//  DataAccess.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/12/2018.
//  Copyright © 2018 Navus. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Realm
import RealmSwift

class DataAccess: NSObject {
    
    private var _roomSelected = BehaviorRelay<Room?>.init(value: nil)
    private var _blockSelected = BehaviorRelay<Block?>.init(value: nil)
    private var _dateSelected = BehaviorRelay<Date?>.init(value: nil)
    
    static var shared = DataAccess()
    
    // API: input, output
    var userSelection: (Int?,Int?,Date?) {
        get {
            return (UserDefaults.standard.value(forKey: "roomId") as? Int,
                    UserDefaults.standard.value(forKey: "sessionId") as? Int,
                    UserDefaults.standard.value(forKey: "date") as? Date
            )
        }
        set {
            UserDefaults.standard.set(newValue.0, forKey: "roomId")
            UserDefaults.standard.set(newValue.1, forKey: "sessionId")
            UserDefaults.standard.set(newValue.2, forKey: "date")
        }
    }
    
    // API: output
    var output: Observable<(Room?, Block?, Date?)> {
        return Observable.combineLatest(_roomSelected.asObservable(),
                                        _blockSelected.asObservable(),
                                        _dateSelected.asObservable(),
            resultSelector: { (room, block, date) -> (Room?, Block?, Date?) in
//            print("emitujem iz DataAccess..room i session za.... \(room?.id), \(block?.id)")
            return (room, block, date)
        })
    }
    
    override init() {
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: "roomId", options: [.initial, .new], context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "sessionId", options: [.initial, .new], context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "date", options: [.initial, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPath = keyPath else {return}
        guard let realm = try? Realm.init() else {return}
        
        if keyPath == "roomId" {
            guard let roomId = UserDefaults.standard.value(forKey: keyPath) as? Int,
                let rRoom = RealmRoom.getRoom(withId: roomId, withRealm: realm) else {
                    return
            }
            let room = Room(from: rRoom)
            _roomSelected.accept(room)
        } else if keyPath == "sessionId" {
            guard let sessionId = UserDefaults.standard.value(forKey: keyPath) as? Int,
                let realmBlock = RealmBlock.getBlock(withId: sessionId, withRealm: realm) else {
                    return
            }
            let block = Block.init(with: realmBlock)
            _blockSelected.accept(block)
        } else if keyPath == "date" {
            guard let date = UserDefaults.standard.value(forKey: keyPath) as? Date else {
                return
            }
            _dateSelected.accept(date)
        }
        
    }
    
}
