//
//  BlockRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 25/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

protocol IBlockRepository {
    //SAVE
    func save(blocks: [Block])
    //GET
    func getBlocks(roomId: Int) -> [Block]
    func getBlocks(roomId: Int, date: Date) -> [Block]
    func getBlock(id: Int) -> Block?
}

class BlockRepository: IBlockRepository {
    
    func save(blocks: [Block]) {
        let realm = try! Realm()
        let rBlocks = blocks.map { (block) -> RealmBlock in
            return RealmBlockFactory.make(block: block)
        }
        try? realm.write {
            realm.add(rBlocks, update: .modified)
        }
    }
    
    func getBlocks(roomId: Int) -> [Block] {
        let realm = try! Realm()
        let blocks = realm.objects(RealmBlock.self).filter("location_id == @i", roomId).toArray()
        return blocks.map(Block.init)
    }
    
    func getBlocks(roomId: Int, date: Date) -> [Block] {
        let blocksInRoom = getBlocks(roomId: roomId)
        let blocksOnDate = blocksInRoom.filter { (block) -> Bool in
            let blockDate = block.starts
            return blockDate.isOnTheSameDay(asDate: date)
        }
        return blocksOnDate
    }
    
    func getBlock(id: Int) -> Block? {
        let realm = try! Realm()
        guard let rBlock = realm.object(ofType: RealmBlock.self, forPrimaryKey: id) else {
            return nil
        }
        return Block(with: rBlock)
    }
}
