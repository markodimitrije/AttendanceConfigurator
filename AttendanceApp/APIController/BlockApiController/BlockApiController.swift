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
    
    func getBlocks(updated_from: Date? = nil, with_pagination: Int = 0, with_trashed: Int = 0, for_scanning: Int = 1) -> Observable<[Block]> {
        let updatedDate = updated_from?.toString(format: Date.defaultFormatString) ?? ""
    //        return buildRequest(pathComponent: "blocks", //params: [ ])//, // testing
    //                            params: [//("updated_from", updatedDate),
    //                                     ("with_pagination", "\(with_pagination)"),
    //                                     ("with_trashed", "\(with_trashed)"),
    //                                     ("for_scanning", "\(for_scanning)")])//,
    //                                     //("type[]", "Oral")])
        let myBaseUrl = BlockApiController.baseUrl.appendingPathComponent("7520/") //hard-coded
            return
                apiController
                    .buildRequest(base: myBaseUrl,
                                  pathComponent: "blocks",
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
    
//    func getBlocks(updated_from: Date? = nil, with_pagination: Int = 0, with_trashed: Int = 0, for_scanning: Int = 1) -> Observable<[Block]>
}

class BlockApiController {
    private var apiController: ApiController
    init(apiController: ApiController) {
        self.apiController = apiController
    }
}
