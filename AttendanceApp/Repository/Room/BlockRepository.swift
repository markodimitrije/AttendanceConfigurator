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
    func save(blocks: [IBlock])
    func replaceExistingWith(blocks: [IBlock])
    //GET
    func getBlocks(roomId: Int) -> [IBlock]
    func getBlocks(roomId: Int, date: Date) -> [IBlock]
    func getBlock(id: Int) -> IBlock?
}

class BlockRepository: IBlockRepository {
    
    func save(blocks: [IBlock]) {
        let realm = try! Realm()
        let rBlocks = blocks.map(RealmBlockFactory.make)
        try? realm.write {
            realm.add(rBlocks, update: .modified)
        }
    }
    
    func replaceExistingWith(blocks: [IBlock]) {
        deleteAllBlocks()
        save(blocks: blocks)
    }
    
    func getBlocks(roomId: Int) -> [IBlock] {
        let realm = try! Realm()
        let rBlocks = realm.objects(RealmBlock.self).filter("location_id == %i", roomId).toArray()
        return rBlocks.map(BlockFactory.make)
    }
    
    func getBlocks(roomId: Int, date: Date) -> [IBlock] {
        let blocksInRoom = getBlocks(roomId: roomId)
        let blocksOnDate = blocksInRoom.filter { (block) -> Bool in
            let blockDate = block.getStartsAt()
            return blockDate.isOnTheSameDay(asDate: date)
        }
        return blocksOnDate
    }
    
    func getBlock(id: Int) -> IBlock? {
        let realm = try! Realm()
        guard let rBlock = realm.object(ofType: RealmBlock.self, forPrimaryKey: id) else {
            return nil
        }
        return BlockFactory.make(from: rBlock)
    }
    
    private func deleteAllBlocks() {
        let realm = try! Realm()
        let previousBlocks = realm.objects(RealmBlock.self)
        try! realm.write {
            realm.delete(previousBlocks)
        }
    }
}
