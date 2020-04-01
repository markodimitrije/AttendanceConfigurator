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
    
    lazy private var _roomSelected = BehaviorRelay<Int?>.init(value: roomInitial)
    lazy private var _blockSelected = BehaviorRelay<Int?>.init(value: sessionInitial)
    lazy private var _dateSelected = BehaviorRelay<Date?>.init(value: dateInitial)
    lazy private var _autoSwitchSelected = BehaviorRelay<Bool>.init(value: autoSwitchInitial)
    
    private var roomInitial: Int?
    private var sessionInitial: Int?
    private var dateInitial: Date?
    private var autoSwitchInitial: Bool
    
    static var shared = DataAccess()
    
    // API: input, output
    var userSelection: (roomId: Int?, blockId: Int?, selectedDate: Date?, autoSwitch: Bool) {
        get {
            return (UserDefaults.standard.value(forKey: "roomId") as? Int,
                    UserDefaults.standard.value(forKey: "sessionId") as? Int,
                    UserDefaults.standard.value(forKey: "date") as? Date,
                    UserDefaults.standard.value(forKey: "autoSwitch") as? Bool ?? true
            )
        }
        set {
            UserDefaults.standard.set(newValue.0, forKey: "roomId")
            UserDefaults.standard.set(newValue.1, forKey: "sessionId")
            UserDefaults.standard.set(newValue.2, forKey: "date")
            UserDefaults.standard.set(newValue.3, forKey: "autoSwitch")
            userDefaultsIsUpdated(forKeyPath: "roomId")
            userDefaultsIsUpdated(forKeyPath: "sessionId")
            userDefaultsIsUpdated(forKeyPath: "date")
            userDefaultsIsUpdated(forKeyPath: "autoSwitch")
        }
    }
    
    // API: output
    var output: Observable<(Int?, Int?, Date?, Bool)> {
        return Observable.combineLatest(_roomSelected.asObservable(),
                                        _blockSelected.asObservable(),
                                        _dateSelected.asObservable(),
                                        _autoSwitchSelected.asObservable(),
            resultSelector: { (room, block, date, autoSwitch) -> (Int?, Int?, Date?, Bool) in
            //print("emitujem iz DataAccess..room i session za.... \(room?.id), \(block?.id), sa blockName = \(block?.name ?? "no  name")")
            return (room, block, date, autoSwitch)
        })
    }
    
    override init() {
        self.roomInitial = UserDefaults.standard.value(forKey: "roomId") as? Int
        self.sessionInitial = UserDefaults.standard.value(forKey: "sessionId") as? Int
        self.dateInitial = UserDefaults.standard.value(forKey: "date") as? Date
        self.autoSwitchInitial = UserDefaults.standard.value(forKey: "autoSwitch") as? Bool ?? true
        super.init()
    }
    
    private func userDefaultsIsUpdated(forKeyPath keyPath: String?) {
        
        guard let keyPath = keyPath else {return}
        
        if keyPath == "roomId" {
            let roomId = UserDefaults.standard.value(forKey: keyPath) as? Int
            _roomSelected.accept(roomId)
        } else if keyPath == "sessionId" {
            let sessionId = UserDefaults.standard.value(forKey: keyPath) as? Int
            _blockSelected.accept(sessionId)
        } else if keyPath == "date" {
            let date = UserDefaults.standard.value(forKey: keyPath) as? Date
            _dateSelected.accept(date)
        } else if keyPath == "autoSwitch" {
            let autoSwitch = UserDefaults.standard.value(forKey: keyPath) as? Bool ?? false
//            print("DataAccess/// emitujem state za autoSwitch = \(autoSwitch)")
            _autoSwitchSelected.accept(autoSwitch)
        }
        
    }
    
}
