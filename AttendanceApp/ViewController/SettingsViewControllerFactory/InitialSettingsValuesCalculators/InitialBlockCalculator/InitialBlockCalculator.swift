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
    let settings: IScanSettings
    let blockRepo: IBlockImmutableRepository
    let initialRoomCalculator: IInitialRoomCalculator
    let initialDateCalculator: IInitialDateCalculator
    func getBlock() -> Int? {
        let savedBlock = settings.blockId
        var block: Int?
        if savedBlock != nil {
            block = savedBlock
        } else if let roomId = initialRoomCalculator.getRoom() {
            let autoBlockViewModel =
                AutoBlockViewModelFactory.make(roomId: roomId, date: initialDateCalculator.getDate())
            if let blockId = try? autoBlockViewModel.selectedBlock.value()?.getId() {
                block = blockId
            } else {
                block = nil
            }
        }
        return block
    }
}
