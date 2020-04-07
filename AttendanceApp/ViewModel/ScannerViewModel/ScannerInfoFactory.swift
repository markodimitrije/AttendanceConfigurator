//
//  ScannerInfoFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 04/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IScannerInfoFactory {
    func make(roomId: Int?, blockId: Int?) -> IScannerInfo
}

extension ScannerInfoFactory: IScannerInfoFactory {
    func make(roomId: Int?, blockId: Int?) -> IScannerInfo {
        guard let roomId = roomId,
            let room = self.roomRepo.getRoom(id: roomId),
            let blockId = blockId,
            let block = self.blockRepo.getBlock(id: blockId) else {
            return ScannerInfo()
        }
        let duration = self.blockPresenter.getDuration(block: block)
        return ScannerInfo(title: block.getName(),
                           description: duration + ", " + room.getName(),
                           blockId: block.getId())
    }
}

struct ScannerInfoFactory {
    let roomRepo: IRoomRepository
    let blockRepo: IBlockImmutableRepository
    let blockPresenter: IBlockPresenter
}
