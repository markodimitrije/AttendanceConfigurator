//
//  BlockImmutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift
import RxSwift

class BlockImmutableRepository: IBlockImmutableRepository {
    
    private func getAllBlockResults() -> Results<RealmBlock> {
        let realm = try! Realm()
        return realm.objects(RealmBlock.self)
            .sorted(byKeyPath: "starts_at", ascending: true)
    }
    
    private func getBlockResults(roomId: Int) -> Results<RealmBlock> {
        let realm = try! Realm()
        return realm.objects(RealmBlock.self)
            .filter("location_id == %i", roomId)
            .sorted(byKeyPath: "starts_at", ascending: true)
    }
    
    func getBlocks(roomId: Int) -> [IBlock] {
        let rBlocks = getBlockResults(roomId: roomId).toArray()
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
    
    func getAvailableDates(roomId: Int?) -> [Date] {
        let blocks = (roomId == nil) ?
            getAllBlockResults().toArray().map(BlockFactory.make) :
            getBlocks(roomId: roomId!)
        let blockDates = blocks.map {$0.getStartsAt()}
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
    
    func getObsBlockGroupedByDate(roomId: Int, date: Date?) -> Observable<[[IBlock]]> {
        let results = getBlockResults(roomId: roomId)
        let obsResults = Observable.collection(from: results).map { (results) -> [[IBlock]] in
            let dates = self.getAvailableDates(roomId: roomId)
            let sections = dates.map {BlockOnDateUtility.makeBlocks(from: results, onDate: $0)}
            return sections
        }
        return obsResults
    }
}

extension RealmBlock: Comparable {
    static func < (lhs: RealmBlock, rhs: RealmBlock) -> Bool {
        lhs.starts_at < rhs.starts_at
    }
}

class BlockOnDateUtility {
    static func makeBlocks(from results: Results<RealmBlock>, onDate date: Date) -> [IBlock] {
        let blocks = results.toArray()
        let blocksOnDate = blocks.filter {$0.starts_at.isOnTheSameDay(asDate: date)}
        return blocksOnDate.map(BlockFactory.make)
    }
}
