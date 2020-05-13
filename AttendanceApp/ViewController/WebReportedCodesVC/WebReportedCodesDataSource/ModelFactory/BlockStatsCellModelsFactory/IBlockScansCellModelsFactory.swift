//
//  IBlockScansCellModelsFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 13/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

protocol IBlockScansCellModelsFactory {
    func make() -> [IBlockStatsTableViewCellModel]
}
