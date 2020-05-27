//
//  SettingsViewModelFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 02/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

class SettingsViewModelFactory {
    static func make() -> SettingsViewModel {
        let blockRepo = BlockImmutableRepositoryFactory.make()
        let scanSettingsRepo = ScanSettingsRepositoryFactory.make()
        return SettingsViewModel(scanSettingsRepo: scanSettingsRepo,
                                 blockRepo: blockRepo,
                                 roomTxtFactory: RoomTxtFactory(roomRepo: RoomRepository()),
                                 blockTxtFactory: BlockTxtFactory(blockRepo: blockRepo))
    }
}

protocol IRoomTxtFactory {
    func getText(roomId: Int?) -> String
}

protocol IBlockTxtFactory {
    func getText(blockId: Int?, autoSwitch: Bool) -> String
}

struct RoomTxtFactory: IRoomTxtFactory {
    let roomRepo: IRoomRepository
    func getText(roomId: Int?) -> String {
        guard let roomId = roomId else {
            return RoomTextData.selectRoom
        }
        return roomRepo.getRoom(id: roomId)?.getName() ?? ""
        
    }
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
