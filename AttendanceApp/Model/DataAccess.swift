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
import RealmSwift

class DataAccess: NSObject {
    
    lazy private var _roomSelected = BehaviorRelay<Int?>.init(value: roomInitial)
    lazy private var _blockSelected = BehaviorRelay<Int?>.init(value: blockInitial)
    lazy private var _dateSelected = BehaviorRelay<Date?>.init(value: dateInitial)
    lazy private var _autoSwitchSelected = BehaviorRelay<Bool>.init(value: autoSwitchInitial)
    
    private var roomInitial: Int?
    private var blockInitial: Int?
    private var dateInitial: Date?
    private var autoSwitchInitial: Bool
    
    static var shared = DataAccess()
    
    // API: input, output
    var userSelection: (roomId: Int?, blockId: Int?, selectedDate: Date?, autoSwitch: Bool) {
        get {
            return (UserDefaults.standard.value(forKey: "roomId") as? Int,
                    UserDefaults.standard.value(forKey: "blockId") as? Int,
                    UserDefaults.standard.value(forKey: "date") as? Date,
                    UserDefaults.standard.value(forKey: "autoSwitch") as? Bool ?? true)
        }
        set {
            UserDefaults.standard.set(newValue.0, forKey: "roomId")
            UserDefaults.standard.set(newValue.1, forKey: "blockId")
            UserDefaults.standard.set(newValue.2, forKey: "date")
            UserDefaults.standard.set(newValue.3, forKey: "autoSwitch")
            _roomSelected.accept(newValue.0)
            _blockSelected.accept(newValue.1)
            _dateSelected.accept(newValue.2)
            _autoSwitchSelected.accept(newValue.3)
        }
    }
    
    func deleteAll() {
        UserDefaults.standard.set(nil, forKey: "roomId")
        UserDefaults.standard.set(nil, forKey: "blockId")
        UserDefaults.standard.set(nil, forKey: "date")
        UserDefaults.standard.set(nil, forKey: "autoSwitch")
        _roomSelected.accept(nil)
        _blockSelected.accept(nil)
        _dateSelected.accept(nil)
        _autoSwitchSelected.accept(false)
    }
    
    // API: output
    var output: Observable<(Int?, Int?, Date?, Bool)> {
        return Observable.combineLatest(_roomSelected.asObservable(),
                                        _blockSelected.asObservable(),
                                        _dateSelected.asObservable(),
                                        _autoSwitchSelected.asObservable(),
            resultSelector: { (room, block, date, autoSwitch) -> (Int?, Int?, Date?, Bool) in
            return (room, block, date, autoSwitch)
        })
    }
    
    override init() {
        self.roomInitial = UserDefaults.standard.value(forKey: "roomId") as? Int
        self.blockInitial = UserDefaults.standard.value(forKey: "blockId") as? Int
        self.dateInitial = UserDefaults.standard.value(forKey: "date") as? Date
        self.autoSwitchInitial = UserDefaults.standard.value(forKey: "autoSwitch") as? Bool ?? true
        super.init()
    }
    
    deinit {
        print("DataAccess.deinit")
    }
    
}
