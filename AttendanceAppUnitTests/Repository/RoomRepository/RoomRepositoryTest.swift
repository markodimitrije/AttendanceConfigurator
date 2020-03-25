//
//  RoomRepositoryTest.swift
//  AttendanceAppUnitTests
//
//  Created by Marko Dimitrijevic on 25/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import XCTest
@testable import AttendanceApp

class RoomRepositoryTest: XCTestCase {
    
    func testRoomsRepository_ShouldBeAbleTo_SaveBlocks() {
        //arrange
        
        let rooms = try! Room(from: <#T##Decoder#>)
        let testSubject = RoomRepository()
        testSubject.save(rooms: <#T##[Room]#>)
    }
}
