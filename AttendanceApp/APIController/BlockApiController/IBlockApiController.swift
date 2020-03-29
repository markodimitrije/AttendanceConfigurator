//
//  IBlockApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 29/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IBlockApiController {
    func getBlocks(updated_from: Date?,
                   with_pagination: Int,
                   with_trashed: Int,
                   for_scanning: Int) -> Observable<[Block]>
}
