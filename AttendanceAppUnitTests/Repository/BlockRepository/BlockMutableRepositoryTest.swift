//
//  BlockMutableRepositoryTest.swift
//  AttendanceAppUnitTests
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AttendanceApp

class BlockMutableRepositoryTest: XCTestCase {
    
    var rooms = [IRoom]()
    var blocks = [IBlock]()
    var testSubject: BlockMutableRepository!
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        self.blocks = BlocksFromJsonFileLoader.make(filename: "Blocks")
        self.rooms = RoomsFromJsonFileLoader.make(filename: "Rooms")
        self.testSubject = BlockMutableRepository()
    }
    
    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        super.tearDown()
    }
    
    func testBlockRepo_ShouldBeAbleTo_SaveBlocks() {
        //arrange
        let block = blocks.first!
        //act
        testSubject.save(blocks: [block])
        //assert
        let realm = try! Realm()
        let found = realm.objects(RealmBlock.self).toArray()
        
        XCTAssertEqual(1,found.count)
        XCTAssertEqual(block.getId(), found.first!.id)
    }
    
}

