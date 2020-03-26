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

    var blocks = [Block]()
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        loadBlocks()
    }
    
    private func loadBlocks() {
        let bundle = Bundle(for: type(of: self))
        let jsonData = JsonBundleDataProvider().jsonData(filename: "Blocks", inBundle: bundle)
        let blocksObject = try! JSONDecoder().decode(Blocks.self, from: jsonData)
        self.blocks = blocksObject.data
    }
    
    override func tearDown() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        super.tearDown()
    }
    
    func testBlockRepository_ShouldBeAbleToSaveBlocks() {
        
    }
    
    private func saveToRealmExplicitely(blocks: [Block], realm: Realm) {
        let rBlocks = blocks.map { (block) -> RealmBlock in
//            let rBlock = RealmBlock()
//            rBlock.updateWith(block: block, withRealm: realm)
//            return rBlock
            return RealmBlockFactory.make(block: block)
        }
        try! realm.write {
            realm.add(rBlocks)
        }
    }
    
}
