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
    var subtitle: String?
    var type: String
    var external_type: String?
    var starts_at: String
    var ends_at: String
    var code: String
    var chairperson: String?
    var block_category_id: Int?
    var imported_id: String
    var has_presentation_on_timeline: Bool
    var has_available_presentation: Bool
    var has_dialog: Bool
    var survey: Bool
    var sponsor_id: Int?
    var topic_id: Int?
    var tags: String
    var featured: Bool
    var updated_at: String
    var location_id: Int
    
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
        self.subtitle = realmBlock.subtitle
        self.type = realmBlock.type
        self.external_type = realmBlock.external_type
        self.starts_at = realmBlock.starts_at
        self.ends_at = realmBlock.ends_at
        self.code = realmBlock.code
        self.chairperson = realmBlock.chairperson
        self.block_category_id = realmBlock.block_category_id
        self.imported_id = realmBlock.imported_id
        self.has_presentation_on_timeline = realmBlock.has_presentation_on_timeline
        self.has_available_presentation = realmBlock.has_available_presentation
        self.has_dialog = realmBlock.has_dialog
        self.survey = realmBlock.survey
        self.sponsor_id = realmBlock.sponsor_id
        self.topic_id = realmBlock.topic_id
        self.tags = realmBlock.tags
        self.featured = realmBlock.featured
        self.updated_at = realmBlock.updated_at
        self.location_id = realmBlock.location_id
    }
    
    private func getOnlyDateString(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else { return "error converting date and time" }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
