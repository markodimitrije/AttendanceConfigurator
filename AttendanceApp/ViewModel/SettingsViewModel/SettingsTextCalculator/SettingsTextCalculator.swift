//
//  SettingsTextCalculator.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

protocol ISettingsTextCalculator {
    func getRoomTxtCalculator() -> IRoomTxtCalculator
    func getBlockTxtCalculator() -> IBlockTxtCalculator
    func getDateTxtCalculator() -> IDateTxtCalculator
}

extension SettingsTextCalculator: ISettingsTextCalculator {
    func getRoomTxtCalculator() -> IRoomTxtCalculator { self.roomTxtCalculator }
    func getBlockTxtCalculator() -> IBlockTxtCalculator { self.blockTxtCalculator }
    func getDateTxtCalculator() -> IDateTxtCalculator { self.dateTxtCalculator }
}

struct SettingsTextCalculator {
    let roomTxtCalculator: IRoomTxtCalculator
    let blockTxtCalculator: IBlockTxtCalculator
    let dateTxtCalculator: IDateTxtCalculator
}
