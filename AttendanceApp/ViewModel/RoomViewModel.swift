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
    
    //hard-coded
    let repo = RoomRepository()
    
    init() {
        bindNewOutput()
    }
    
    // input
    var selectedTableIndex: BehaviorSubject<Int?> = BehaviorSubject.init(value: nil)
    
    // output
    
    private(set) var obsRooms: Observable<[RoomSectionOfCustomData]>!
    
    private(set) var selectedRoom = BehaviorSubject<RealmRoom?>.init(value: nil)
    
    // MARK:- calculators
    
    func getRoom(forSelectedTableIndex index: Int) -> IRoom {//TODO: IRoom
        let rooms = repo.getAllRooms()
        return rooms[index]
    }
    
    // MARK:- Private methods
    
    private func bindNewOutput() {
        
        self.obsRooms = repo.getObsAllRooms().map(RoomSectionFactory.make)
        
    }

}

class RoomSectionFactory {
    static func make(rooms: [IRoom]) -> [RoomSectionOfCustomData] {
        let items = rooms.map {RoomSectionOfCustomData.Item(name: $0.getName())}
        return [RoomSectionOfCustomData(header: "", items: items)]
    }
}
