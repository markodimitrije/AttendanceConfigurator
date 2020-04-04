//
//  Block.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 22/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RealmSwift

struct Blocks: Codable {
    var data: [Block]
}

extension Block: IBlock {
    func getId() -> Int { return self.id }
    func getName() -> String { return self.name }
    func getLocationId() -> Int { return self.location_id }
    func getStartsAt() -> Date { return self.starts_at }
    func getEndsAt() -> Date { return self.ends_at }
    func getClosed() -> Bool { return self.closed }
}

struct Block: Codable {
    var id: Int
    var name: String
    var location_id: Int
    var starts_at: Date
    var ends_at: Date
    var closed: Bool
    
    var startsShort: String {
        starts_at.toString(format: "yyyy-MM-dd") ?? "error"
    }
    
//    var duration: String {
//         let timeStartsAt = self.getStartsAt().toString(format: Date.timeFormatString) ?? "err"
//         let timeEndsAt = self.getEndsAt().toString(format: Date.timeFormatString) ?? "err"
//
//         return timeStartsAt + "-" + timeEndsAt
//    }

}

protocol IBlockPresenter {
    func getDuration(block: IBlock) -> String
    func getShortStartDate(block: IBlock) -> String
}

struct BlockPresenter: IBlockPresenter {
    func getDuration(block: IBlock) -> String {
        let timeStartsAt = block.getStartsAt().toString(format: Date.timeFormatString) ?? "err"
        let timeEndsAt = block.getEndsAt().toString(format: Date.timeFormatString) ?? "err"
        return timeStartsAt + "-" + timeEndsAt
    }
    func getShortStartDate(block: IBlock) -> String {
        block.getStartsAt().toString(format: Date.shortDateFormatString) ?? "err"
    }
}
