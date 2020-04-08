//
//  RealmViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 20/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

class RoomViewModel {
    
    private let disposeBag = DisposeBag()
    
    //hard-coded
    let repo = RoomRepository()
    
    init() {
        bindNewOutput()
    }
    
    // MARK:- Output
    private(set) var obsRooms: Observable<[RoomsSectionOfCustomData]>!
    
    // MARK:- API
    func getRoom(forSelectedTableIndex index: Int) -> IRoom {
        let rooms = repo.getAllRooms()
        return rooms[index]
    }
    
    // MARK:- Private methods
    
    private func bindNewOutput() {
        self.obsRooms = repo.getObsAllRooms().map(RoomsSectionOfCustomDataFactory.make)
    }

}
