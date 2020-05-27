//
//  BlockTxtFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 27/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IBlockTxtFactory {
    func getText(blockId: Int?, autoSwitch: Bool) -> String
}

struct BlockTxtFactory: IBlockTxtFactory {
    let blockRepo: IBlockImmutableRepository
    func getText(blockId: Int?, autoSwitch: Bool) -> String {
        if let blockId = blockId,
            let blockName = self.blockRepo.getBlock(id: blockId)?.getName() {
                return blockName
        } else {
            if autoSwitch {
                return SessionTextData.noAutoSessAvailable
            } else {
                return SessionTextData.selectSessionManually
            }
        }
    }
}
