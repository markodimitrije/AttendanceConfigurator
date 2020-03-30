//
//  IRoomApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IRoomApiController {
    func getRooms(updated_from: Date?, with_pagination: Int, with_trashed: Int) -> Observable<[Room]>
}
