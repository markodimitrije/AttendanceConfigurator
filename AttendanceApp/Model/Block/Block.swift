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
    func get_Starts_At() -> String { return self.starts_at} // TODO marko DRY!
    func get_Ends_At() -> String { return self.ends_at}
    
    func getId() -> Int { return self.id }
    func getName() -> String { return self.name }
    func getLocationId() -> Int { return self.location_id }
    func getStartsAt() -> Date { return self.starts } // TODO marko DRY!
    func getEndsAt() -> Date { return self.ensds }
    func getClosed() -> Bool { return self.closed }
}

struct Block: Codable {
    var id: Int
    var name: String
    var location_id: Int
    var starts_at: String
    var ends_at: String
    var closed: Bool
    
    // helpers vars
    var starts: Date { return Date.parse(self.starts_at) }
    var ensds: Date { return Date.parse(self.starts_at) }
    
    var startsShort: String {
        starts_at.toDateWithNoTimeString(inputFormat: Date.defaultFormatString,
                                         outputFormat: "yyyy-MM-dd")
    }
    
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
}
