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
