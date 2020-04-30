//
//  RoomRepositoryTest.swift
//  AttendanceAppUnitTests
//
//  Created by Marko Dimitrijevic on 25/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AttendanceApp

class RoomRepositoryTest: XCTestCase {
    
    var rooms = [IRoom]()
    var testSubject: RoomRepository!
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        self.rooms = RoomsFromJsonFileLoader.make(filename: "Rooms")
        self.testSubject = RoomRepository()
    }
    
    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        super.tearDown()
    }
    
    func testRoomsRepository_ShouldBeAbleTo_SaveRooms() {
        //arrange
        let room = rooms.first!
        //act
        testSubject.save(rooms: [room])
        //assert
        let realm = try! Realm()
        let found = realm.objects(RealmRoom.self).toArray()
        XCTAssertEqual(1, found.count)
    }
    
    func testRoomsRepository_GetRoom_ShouldReturnNil_ForNonExistinId() {
        //arrange
        SaveRoomsToRealmExplicitelyHelper.save(rooms: [rooms.first!])
        //act
        let room = testSubject.getRoom(id: 123456)
        //assert
        XCTAssertNil(room)
    }
    
    func testRoomsRepository_ShouldBeAbleTo_GetRoom_WithExistingId() {
        //arrange
        SaveRoomsToRealmExplicitelyHelper.save(rooms: [rooms.first!])
        //act
        let room = testSubject.getRoom(id: 4456)
        //assert
        XCTAssertNotNil(room)
    }
    
    func testRoomsRepository_getAllRooms_ShouldReturn_ExpectedRooms() {
        //arrange
        SaveRoomsToRealmExplicitelyHelper.save(rooms: [rooms.first!, rooms.last!])
        //act
        let found = testSubject.getAllRooms()
        //assert
        XCTAssertEqual(2, found.count)
    }
    
}
