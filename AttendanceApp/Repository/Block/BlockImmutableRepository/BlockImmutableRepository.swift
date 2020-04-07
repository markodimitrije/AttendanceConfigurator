//
//  BlockImmutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

class BlockImmutableRepository: IBlockImmutableRepository {
    
    func getBlocks(roomId: Int) -> [IBlock] {
        let realm = try! Realm()
        let rBlocks = realm.objects(RealmBlock.self).filter("location_id == %i", roomId).toArray()
        return rBlocks.map(BlockFactory.make)
    }
    
    func getBlocks(roomId: Int, date: Date) -> [IBlock] {
        let blocksInRoom = getBlocks(roomId: roomId)
        let blocksOnDate = blocksInRoom.filter { (block) -> Bool in
            let blockDate = block.getStartsAt()
            return blockDate.isOnTheSameDay(asDate: date)
        }
        return blocksOnDate
    }
    
    func getBlock(id: Int) -> IBlock? {
        let realm = try! Realm()
        guard let rBlock = realm.object(ofType: RealmBlock.self, forPrimaryKey: id) else {
            return nil
        }
        return BlockFactory.make(from: rBlock)
    }
    
    func getAvailableDates(roomId: Int) -> [Date] {
        
        let realm = try! Realm()
        let blockDates = realm.objects(RealmBlock.self).filter("location_id == %i", roomId).toArray().map {$0.starts_at}
        
        var daysSet = Set<Date>()
        
        _ = blockDates.map { date in
            let shortDateStr = date.toString(format: Date.shortDateFormatString)!
            let formatter = DateFormatter(format: Date.shortDateFormatString)
            let shortDate = formatter.date(from: shortDateStr)!
            daysSet.insert(shortDate)
        }
        return daysSet.sorted()
    }
    
    func getBlockGroupedByDate(roomId: Int, date: Date?) -> [[IBlock]] {
        if let date = date {
            let blocksOnDate = getBlocks(roomId: roomId, date: date)
            return [blocksOnDate]
        } else {
            let dates = getAvailableDates(roomId: roomId)
            let blocksGroupedByDate = dates.map { getBlocks(roomId: roomId, date: $0)}
            return blocksGroupedByDate
        }
    }
}

extension RealmBlock: Comparable {
    static func < (lhs: RealmBlock, rhs: RealmBlock) -> Bool {
        lhs.starts_at < rhs.starts_at
    }
}