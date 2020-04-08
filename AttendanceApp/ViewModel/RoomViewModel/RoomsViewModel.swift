//
//  RoomsViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 20/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

class RoomsViewModel: IRoomsViewModel {
    
    private let disposeBag = DisposeBag()
    private let roomRepository: IRoomRepository
    
    init(roomRepository: IRoomRepository) {
        self.roomRepository = roomRepository
        bindRoomsToOutput()
    }
    
    // MARK:- Output
    var obsRooms: Observable<[RoomsSectionOfCustomData]>!
    
    // MARK:- API
    func getRoom(forSelectedTableIndex index: Int) -> IRoom {
        let rooms = roomRepository.getAllRooms()
        return rooms[index]
    }
    
    // MARK:- Private methods
    
    private func bindRoomsToOutput() {
        self.obsRooms = roomRepository.getObsAllRooms().map(RoomsSectionOfCustomDataFactory.make)
    }

}
