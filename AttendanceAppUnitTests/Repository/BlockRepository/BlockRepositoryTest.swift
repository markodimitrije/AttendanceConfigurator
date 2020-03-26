//
//  BlockRepositoryTest.swift
//  AttendanceAppUnitTests
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AttendanceApp

class BlockRepositoryTest: XCTestCase {

    var rooms = [IRoom]()
    var blocks = [IBlock]()
    var testSubject: BlockRepository!
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        self.blocks = BlocksFromJsonFileLoader.make(filename: "Blocks")
        self.rooms = RoomsFromJsonFileLoader.make(filename: "Rooms")
        self.testSubject = BlockRepository()
    }
    
    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        super.tearDown()
    }
    
    func testBlockRepository_ShouldBeAbleTo_SaveBlocks() {
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
    
    func testBlockRepository_ShouldBeAbleTo_GetBlock_WithExistingId() {
        //arrange
        let block = blocks.first!
        SaveBlocksToRealmExplicitelyHelper.save(blocks: [block])
        //act
        let found = testSubject.getBlock(id: block.getId())
        //assert
        XCTAssertNotNil(found)
    }
    
    func testBlockRepository_GetBlockFucn_ShouldReturnNil_ForNonExistingId() {
        //arrange
        let block = blocks.first!
        SaveBlocksToRealmExplicitelyHelper.save(blocks: [block])
        //act
        let found = testSubject.getBlock(id: 123456)
        //assert
        XCTAssertNil(found)
    }
    
    func testBlockRepository_ShouldBeAbleTo_GetAllBlocks_WithLocationId() {
        //arrange
        SaveRoomsToRealmExplicitelyHelper.save(rooms: self.rooms)
        SaveBlocksToRealmExplicitelyHelper.save(blocks: self.blocks)
        //act
        let roomId = rooms.first!.getId()
        let blocks = testSubject.getBlocks(roomId: roomId)
        //assert
        XCTAssertEqual(20, blocks.count) // data have 4 rooms by 5 sessions
    }
    
    func testBlockRepository_GetAllBlocks_ShouldReturnNil_ForLocationId_OnNonMatchingDate() {
        //act
        let roomId = rooms.first!.getId()
        let nonMatchingDate = Date.init(timeIntervalSince1970: 0)
        let blocks = testSubject.getBlocks(roomId: roomId, date: nonMatchingDate)
        //assert
        XCTAssertEqual(0, blocks.count)
    }
    
    func testBlockRepository_GetAllBlocks_ShouldReturnBlocks_ForLocationId_OnMatchingDate() {
        //arrange
        SaveRoomsToRealmExplicitelyHelper.save(rooms: self.rooms)
        SaveBlocksToRealmExplicitelyHelper.save(blocks: self.blocks)
        //arrange
        let roomId = 4456
        let date = "2020-03-24".toDate(format: "YYYY-MM-dd")!
        //act
        let blocks = testSubject.getBlocks(roomId: roomId, date: date)
        //assert
        XCTAssertEqual(5, blocks.count)
    }
    
}
