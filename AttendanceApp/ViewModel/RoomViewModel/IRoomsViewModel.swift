//
//  IRoomsViewModel.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IRoomsViewModel {
    var obsRooms: Observable<[RoomsSectionOfCustomData]>! {get set}
    func getRoom(forSelectedTableIndex index: Int) -> IRoom
}
