//
//  BlockMutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class BlockMutableRepository: IBlockMutableRepository {
    
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
    
    func deleteAllBlocks() {
        let realm = try! Realm()
        let previousBlocks = realm.objects(RealmBlock.self)
        try! realm.write {
            realm.delete(previousBlocks)
        }
    }
}
