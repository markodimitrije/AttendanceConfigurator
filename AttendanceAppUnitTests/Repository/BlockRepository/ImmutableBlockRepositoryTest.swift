//
//  ImmutableBlockRepositoryTest.swift
//  AttendanceAppUnitTests
//
//  Created by Marko Dimitrijevic on 26/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AttendanceApp

class ImmutableBlockRepositoryTest: XCTestCase {

    var rooms = [IRoom]()
    var blocks = [IBlock]()
    var testSubject: BlockImmutableRepository!
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        self.blocks = BlocksFromJsonFileLoader.make(filename: "Blocks")
        self.rooms = RoomsFromJsonFileLoader.make(filename: "Rooms")
        self.testSubject = BlockImmutableRepository()
    }
    
    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        super.tearDown()
    }
    
    func testBlockRepo_ShouldBeAbleTo_GetBlock_WithExistingId() {
        //arrange
        let block = blocks.first!
        SaveBlocksToRealmExplicitelyHelper.save(blocks: [block])
        //act
        let found = testSubject.getBlock(id: block.getId())
        //assert
        XCTAssertNotNil(found)
    }
    
    func testBlockRepo_GetBlockFucn_ShouldReturnNil_ForNonExistingId() {
        //arrange
        let block = blocks.first!
        SaveBlocksToRealmExplicitelyHelper.save(blocks: [block])
        //act
        let found = testSubject.getBlock(id: 123456)
        //assert
        XCTAssertNil(found)
    }
    
    func testBlockRepo_ShouldBeAbleTo_GetAllBlocks_WithLocationId() {
        //arrange
        SaveRoomsToRealmExplicitelyHelper.save(rooms: self.rooms)
        SaveBlocksToRealmExplicitelyHelper.save(blocks: self.blocks)
        //act
        let roomId = rooms.first!.getId()
        let blocks = testSubject.getBlocks(roomId: roomId)
        //assert
        XCTAssertEqual(20, blocks.count) // data have 4 rooms by 5 sessions
    }
    
    func testBlockRepo_GetAllBlocks_ShouldReturnNil_ForLocationId_OnNonMatchingDate() {
        //act
        let roomId = rooms.first!.getId()
        let nonMatchingDate = Date.init(timeIntervalSince1970: 0)
        let blocks = testSubject.getBlocks(roomId: roomId, date: nonMatchingDate)
        //assert
        XCTAssertEqual(0, blocks.count)
    }
    
    func testBlockRepo_GetAllBlocks_ShouldReturnBlocks_ForLocationId_OnMatchingDate() {
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
    
    func testBlockRepo_getAvailableDatesFunc_ShouldReturn_ExpectedDates() {
        //arrange
        SaveBlocksToRealmExplicitelyHelper.save(blocks: self.blocks)
        //act
        let dates = testSubject.getAvailableDates(roomId: 4457)
        //assert
        XCTAssertEqual(4, dates.count) // test bundle event lasts 4 days
    }
    
    func testBlockRepo_getBlockGroupedByDate_ShouldReturn_ExpectedBlockGroups_ForDateNil() {
        //arrange
        SaveBlocksToRealmExplicitelyHelper.save(blocks: self.blocks)
        //act
        let blockGroups = testSubject.getBlockGroupedByDate(roomId: 4457, date: nil)
        //assert
        XCTAssertEqual(4, blockGroups.count) // test bundle event lasts 4 days
        XCTAssertEqual(5, blockGroups.first!.count) // first group has 5 blocks
    }
    
    func testBlockRepo_getBlockGroupedByDate_ShouldReturn_ExpectedBlockGroups_ForCertainDate() {
        //arrange
        SaveBlocksToRealmExplicitelyHelper.save(blocks: self.blocks)
        let date = "2020-03-24".toDate(format: "YYYY-MM-dd")!
        //act
        let blockGroups = testSubject.getBlockGroupedByDate(roomId: 4457, date: date)
        //assert
        XCTAssertEqual(1, blockGroups.count) // test bundle event lasts 4 days
        XCTAssertEqual(5, blockGroups.first!.count) // first group has 5 blocks
    }
    
}
