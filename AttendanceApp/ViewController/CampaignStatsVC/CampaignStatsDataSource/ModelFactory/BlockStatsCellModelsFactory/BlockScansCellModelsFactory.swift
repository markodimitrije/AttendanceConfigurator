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
    
    func make() -> [IBlockScansTableViewCellModel] {
        let blocks = blockRepo.getBlocks()
        let scansPerBlockId = makeDictScansForBlockId(blocks: blocks)
        
        let blocksByScan = blocks.sorted { (blockA, blockB) -> Bool in
            scansPerBlockId[blockA.getId()]! > scansPerBlockId[blockB.getId()]!
        }
        
        let cellModels = blocksByScan.map { (block) -> BlockScansTableViewCellModel in
            let scansCount = scansPerBlockId[block.getId()]!
            let roomName = roomRepo.getRoom(id: block.getLocationId())?.getName() ?? ""
            return BlockScansTableViewCellModel(date: block.getStartsAt(),
                                                room: roomName,
                                                title: block.getName(),
                                                count: "Scans: \(scansCount)")
        }
        return cellModels
        
    }
    
    private func makeDictScansForBlockId(blocks: [IBlock]) -> [Int: Int] {
        var scansForBlockId = [Int: Int]()
        _ = blocks.map {scansForBlockId[$0.getId()] = codeRepo.getTotalScansCount(blockId: $0.getId())}
        return scansForBlockId
    }
}
