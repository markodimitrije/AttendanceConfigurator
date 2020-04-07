//
//  BlockViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 20/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift
import RxSwift
import RxRealm
import RxCocoa

protocol IBlockViewModel {
    func getItems(date: Date?) -> Observable<[SectionOfCustomData]>
}

class BlockViewModel {
    
    private let disposeBag = DisposeBag()
    
    // ovi treba da su ti SUBJECTS! sta je poenta imati ih ovako ??
    
    private var blocks: Results<RealmBlock>! // ostavio sam zbog vc-a.. (nije dobro ovo)
//    private (set) var blocksSortedByDate = [RealmBlock]()

    private (set) var sectionBlocks = [[RealmBlock]]() // niz nizova jer je tableView sa sections
    
    private var blocksSortedByDate = [RealmBlock]()
    
    // output 1 - za prikazivanje blocks na tableView...
    
    private var oSectionsHeadersAndItems = BehaviorRelay<[SectionOfCustomData]>.init(value: [])
    
    // output 2 - expose your calculated stuff
    var oAutomaticSession = BehaviorRelay<Block?>.init(value: nil)
    
    private let roomId: Int?
    private let blockRepository: IBlockImmutableRepository
    private let mostRecentBlockUtility: IMostRecentBlockUtility
    
    private var mostRecentSessionBlock: RealmBlock? {
        return mostRecentBlockUtility
            .getMostRecentSession(blocksSortedByDate: self.blocksSortedByDate)
    }
    
    init(roomId: Int? = nil, blockRepository: IBlockImmutableRepository, mostRecentBlockUtility: IMostRecentBlockUtility) {
        self.roomId = roomId
        self.blockRepository = blockRepository
        self.mostRecentBlockUtility = mostRecentBlockUtility
        bindOutput()
        bindAutomaticSession()
    }
    
    // 3 - output
    
    private(set) var oBlocks: Observable<(AnyRealmCollection<RealmBlock>, RealmChangeset?)>!
    
    private func bindOutput() { // hook-up se za Realm, sada su Rooms synced sa bazom
        
        guard let realm = try? Realm() else { return }
        
        // ovde mi treba jos da su od odgovarajuceg Room-a
        
        blocks = realm.objects(RealmBlock.self)
        
        if let roomId = roomId {
            blocks = blocks.filter("location_id = %@", roomId)
        }
        
        oBlocks = Observable.changeset(from: blocks)
        
        oBlocks
            .subscribe(onNext: { (collection, changeset) in
                
                self.sectionBlocks = self.sortBlocksByDay(blocksArray: collection.toArray())
                
                self.blocksSortedByDate = collection.toArray().sorted(by: {
                    //return Date.parse($0.starts_at) < Date.parse($1.starts_at)
                    return $0.starts_at < $1.starts_at // TODO marko: just <
                })
                
                self.loadSectionsHeadersAndItems(blocksByDay: self.sectionBlocks)
                
            }).disposed(by: disposeBag)
        
    }
    
    private func loadSectionsHeadersAndItems(blocksByDay: [[RealmBlock]]) {
        let items = blocksByDay.map({ (blocks) -> SectionOfCustomData in
            //let sectionName = blocks.first?.starts_at.components(separatedBy: " ").first ?? ""
            let sectionName = blocks.first?.starts_at.toString(format: "yyyy-MM-dd") ?? ""
            let items = blocks.map({ (rBlock) -> SectionOfCustomData.Item in
                let format = Date.defaultFormatString
                let fullname = rBlock.starts_at.toString(format: format)! + " " + rBlock.name
                let name = rBlock.name
                let date = rBlock.starts_at
                return SectionOfCustomData.Item(fullname: fullname, name: name, date: date)
            })
            return SectionOfCustomData.init(header: sectionName, items: items)
        })
        oSectionsHeadersAndItems.accept(items)
    }
    
    // ako ima bilo koji session u zadatom Room, na koji se ceka krace od 2 sata, emituj SessionId; ako nema, emituj nil.
    private func bindAutomaticSession(interval: TimeInterval = MyTimeInterval.waitToMostRecentSession) {
        
        let sessionAvailable = autoSessionIsAvailable(inLessThan: interval)
        
        if sessionAvailable {
            //let block = Block(with: mostRecentSessionBlock!)
            let block = BlockFactory.make(from: mostRecentSessionBlock!) as! Block
            oAutomaticSession.accept(block)
        } else {
            oAutomaticSession.accept(nil)
        }
         
    }
    
    private func autoSessionIsAvailable(inLessThan interval: TimeInterval) -> Bool { // implement me
        
        return mostRecentSessionBlock != nil
        
    }
    
    private func sortBlocksByDay(blocksArray:[RealmBlock]) -> [[RealmBlock]] {
        
        if blocksArray.isEmpty { return [] }
        
//        let inputArray = blocksArray.sorted { Date.parse($0.starts_at) < Date.parse($1.starts_at) }
        let inputArray = blocksArray.sorted { $0.starts_at < $1.starts_at }
        
        var resultArray = [[inputArray[0]]]
        
        let calendar = Calendar(identifier: .gregorian)
        for (prevBlock, nextBlock) in zip(inputArray, inputArray.dropFirst()) {
            let prevDate = prevBlock.starts_at
            let nextDate = nextBlock.starts_at
            if !calendar.isDate(prevDate, equalTo: nextDate, toGranularity: .day) {
                resultArray.append([]) // Start new row
            }
            resultArray[resultArray.count - 1].append(nextBlock)
        }
        return resultArray
    }
    
    // API:
    func getItems(date: Date?) -> BehaviorRelay<[SectionOfCustomData]> {
        return self.oSectionsHeadersAndItems
    }
    
    //deinit { print("deinit/BlockViewModel is deinit") }
    
}
