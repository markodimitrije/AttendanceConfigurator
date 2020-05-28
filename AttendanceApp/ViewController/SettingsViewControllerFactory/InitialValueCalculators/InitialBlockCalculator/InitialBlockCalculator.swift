//
//  InitialBlockCalculator.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IInitialBlockCalculator {
    func getBlock() -> Int?
}

struct InitialBlockCalculator: IInitialBlockCalculator {
    let settings = ScanSettingsRepositoryFactory.make().getScanSettings()
    let blockRepo = BlockImmutableRepository()
    let initialRoomFactory = InitialRoomCalculator()
    let initialDateFactory = InitialDateCalculator()
    func getBlock() -> Int? {
        let savedBlock = settings.blockId
        var block: Int?
        if savedBlock != nil {
            block = savedBlock
        } else if let roomId = initialRoomFactory.getRoom() {
            let autoBlockViewModel =
                AutoBlockViewModelFactory.make(roomId: roomId, date: initialDateFactory.getDate())
            if let blockId = try? autoBlockViewModel.selectedBlock.value()?.getId() {
                block = blockId
            } else {
                block = nil
            }
        }
        return block
    }
}
