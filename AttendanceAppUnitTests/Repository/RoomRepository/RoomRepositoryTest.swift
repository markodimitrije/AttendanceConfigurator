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
    
    var rooms = [Room]()
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        loadRooms()
    }
    
    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        super.tearDown()
    }
    
    private func loadRooms() {
        let bundle = Bundle(for: type(of: self))
        let jsonData = JsonBundleDataProvider().jsonData(filename: "Rooms", inBundle: bundle)
        let roomsObject = try! JSONDecoder().decode(Rooms.self, from: jsonData)
        self.rooms = roomsObject.data
    }
    
    func testRoomsRepository_ShouldBeAbleTo_SaveRooms() {
        //arrange
        let room = rooms.first!
        let testSubject = RoomRepository()
        //act
        testSubject.save(rooms: [room])
        //assert
        let realm = try! Realm()
        let found = realm.objects(RealmRoom.self).toArray()
        XCTAssertEqual(1, found.count)
    }
    
    func testRoomsRepository_GetRoom_ShouldReturnNil_ForNonExistinId() {
        //arrange
        saveToRealmExplicitely(room: rooms.first!)
        let testSubject = RoomRepository()
        //act
        let room = testSubject.getRoom(id: 123456)
        //assert
        XCTAssertNil(room)
    }
    
    func testRoomsRepository_ShouldBeAbleTo_GetRoom_WithExistingId() {
        //arrange
        saveToRealmExplicitely(room: rooms.first!)
        let testSubject = RoomRepository()
        //act
        let room = testSubject.getRoom(id: 4509)
        //assert
        XCTAssertNotNil(room)
    }
    
    private func saveToRealmExplicitely(room: Room) {
        let rRoom = RealmRoom()
        rRoom.updateWith(room: room)
        let realm = try! Realm()
        try! realm.write {
            realm.add(rRoom)
        }
    }
}
