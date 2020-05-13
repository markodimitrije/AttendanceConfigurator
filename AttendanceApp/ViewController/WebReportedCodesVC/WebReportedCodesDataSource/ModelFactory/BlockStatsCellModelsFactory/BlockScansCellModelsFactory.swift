//
//  BlockScansCellModelsFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 13/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

struct BlockScansCellModelsFactory: IBlockScansCellModelsFactory {
    let codeRepo: ICodeReportsRepository
    let roomRepo: IRoomRepository
    let blockRepo: IBlockImmutableRepository
    
    func make() -> [IBlockStatsTableViewCellModel] {
        let blocks = blockRepo.getBlocks()
        let scans = blocks.map { codeRepo.getTotalScansCount(blockId: $0.getId()) }.sorted(by: >)
        let cellModels = scans.enumerated().map { (index, scans) -> BlockStatsTableViewCellModel in
            let block = blocks[index]
            let roomName = roomRepo.getRoom(id: block.getLocationId())?.getName() ?? ""
            return BlockStatsTableViewCellModel(date: block.getStartsAt(),
                                                room: roomName,
                                                title: block.getName(),
                                                count: "Scans: \(scans)")
        }
        return cellModels
    }
}
