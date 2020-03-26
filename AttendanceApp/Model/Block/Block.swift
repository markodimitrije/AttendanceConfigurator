//
//  Block.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 22/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Blocks: Codable {
    var data: [Block]
}

extension Block: IBlock {
    func get_Starts_At() -> String { return self.starts_at} // TODO marko DRY!
    func get_Ends_At() -> String { return self.ends_at}
    
    func getId() -> Int { return self.id }
    func getName() -> String { return self.name }
    func getLocationId() -> Int { return self.location_id }
    func getStartsAt() -> Date { return self.starts } // TODO marko DRY!
    func getEndsAt() -> Date { return self.ensds }
    func getClosed() -> Bool { return self.closed }
}

class Block: Codable {
    var id: Int
    var name: String
    var location_id: Int
    var starts_at: String
    var ends_at: String
    var closed: Bool
    
    // helpers vars
    var starts: Date { return Date.parse(self.starts_at) }
    var ensds: Date { return Date.parse(self.starts_at) }
    
    var startsShort: String { return getOnlyDateString(from: starts_at) }
    
    var duration: String {
        
        let timeStartsAt = Date.parseIntoTime(starts_at, outputWithSeconds: false)
        let timeEndsAt = Date.parseIntoTime(ends_at, outputWithSeconds: false)
        
        let calendar = Calendar.init(identifier: .gregorian)
        
        let timeDuration = timeStartsAt + "-" + timeEndsAt
        
        if calendar.isDateInToday(Date.parse(starts_at)) {
            return timeDuration
        } else {
            return Date.parseIntoDateOnly(starts_at) + " " + timeDuration
        }
        
    }
    
    /*
    init?(dict: [String: Any]) {
        guard
            let id = dict["id"] as? Int,
            let name = dict["name"] as? String,
            let location_id = dict["location_id"] as? Int,
            let starts_at = dict["starts_at"] as? String,
            let ends_at = dict["ends_at"] as? String,
            let closed = dict["closed"] as? Bool else {
                return nil
        }
        self.id = id
        self.name = name
        self.location_id = location_id
        self.starts_at = starts_at
        self.ends_at = ends_at
        self.closed = closed
    }
    */
    
    init(with realmBlock: RealmBlock) {
        self.id = realmBlock.id
        self.name = realmBlock.name
        self.location_id = realmBlock.location_id
        self.starts_at = realmBlock.starts_at
        self.ends_at = realmBlock.ends_at
        self.closed = realmBlock.closed
    }
    
    private func getOnlyDateString(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else { return "error converting date and time" }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
