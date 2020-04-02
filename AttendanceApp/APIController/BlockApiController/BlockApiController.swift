//
//  BlockApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension BlockApiController: IBlockApiController {
    
    static let baseUrl = URL(string: "https://service.e-materials.com/api/conferences/")!
//    static let baseUrl = URL(string: "https://b276c755-37f6-44d2-85af-6f3e654511ad.mock.pstmn.io/")!
    
    func getBlocks(updated_from: Date? = nil, with_pagination: Int = 0, with_trashed: Int = 0, for_scanning: Int = 1) -> Observable<[Block]> {
        let updatedDate = updated_from?.toString(format: Date.defaultFormatString) ?? ""
        let myBaseUrl = BlockApiController.baseUrl.appendingPathComponent("\(confId)")
            return
                apiController
                .buildRequest(base: myBaseUrl,
                              pathComponent: "/blocks",
                              params: [("updated_from", updatedDate),
                                       ("with_pagination", "\(with_pagination)"),
                                       ("with_trashed", "\(with_trashed)"),
                                       ("for_scanning", "\(for_scanning)"),
                                       ("type[]", "Oral")])
                .map() { data in
                    let decoder = JSONDecoder()
                    guard let blocks = try? decoder.decode(Blocks.self, from: data) else {
                        throw ApiError.invalidJson
                    }
                    return blocks.data
                }
    }
    
}

class BlockApiController {
    private let apiController: ApiController
    private let confId: Int
    init(apiController: ApiController, confId: Int) {
        self.apiController = apiController
        self.confId = confId
    }
}
