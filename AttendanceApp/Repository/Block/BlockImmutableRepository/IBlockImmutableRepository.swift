//
//  IBlockImmutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IBlockImmutableRepository {
    func getBlocks(roomId: Int) -> [IBlock]
    func getBlocks(roomId: Int, date: Date) -> [IBlock]
    func getBlock(id: Int) -> IBlock?
    func getAvailableDates(roomId: Int?) -> [Date]
    func getBlockGroupedByDate(roomId: Int, date: Date?) -> [[IBlock]]
    func getObsBlockGroupedByDate(roomId: Int, date: Date?) -> Observable<[[IBlock]]>
}
