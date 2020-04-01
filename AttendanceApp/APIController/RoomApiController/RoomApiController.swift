//
//  RoomApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 30/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension RoomApiController: IRoomApiController {
    
    //static let baseUrl = URL(string: "https://service.e-materials.com/api/conferences/")!
    static let baseUrl = URL(string: "https://b276c755-37f6-44d2-85af-6f3e654511ad.mock.pstmn.io/")!
    
    func getRooms(updated_from: Date? = nil, with_pagination: Int = 0, with_trashed: Int = 0) -> Observable<[Room]> {
        
        let updatedDate = updated_from?.toString(format: Date.defaultFormatString) ?? ""
        let myBaseUrl = RoomApiController.baseUrl.appendingPathComponent("\(self.confId)") //hard-coded
        return apiController
            .buildRequest(base: myBaseUrl,
                          pathComponent: "/locations", //params: [])//,
                          params: [("updated_from", updatedDate),
                                   ("with_pagination", "\(with_pagination)"),
                                   ("with_trashed", "\(with_trashed)")])
            .map() { json in
                let decoder = JSONDecoder()
                guard let rooms = try? decoder.decode(Rooms.self, from: json) else {
                    throw ApiError.invalidJson
                }
                return rooms.data
            }
    }
    
}

class RoomApiController {
    private var apiController: ApiController
    private var confId: Int
    init(apiController: ApiController, confId: Int) {
        self.apiController = apiController
        self.confId = confId
    }
}
