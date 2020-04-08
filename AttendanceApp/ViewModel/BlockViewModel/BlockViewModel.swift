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
    func transform(indexPath: IndexPath) -> IBlock
}

class BlockViewModel {
    
    private let disposeBag = DisposeBag()
    
    // TODO: remove by new one...
    private (set) var sectionBlocks = [[RealmBlock]]() // niz nizova jer je tableView sa sections
    private (set) var newSectionBlocks = [[IBlock]]() // niz nizova jer je tableView sa sections
    
    private var blocksSortedByDate = [RealmBlock]()
    
    // output 1 - za prikazivanje blocks na tableView...
    
    private var oSectionsHeadersAndItems = BehaviorRelay<[SectionOfCustomData]>.init(value: [])
    
    // output 2 - expose your calculated stuff
    var oAutomaticSession = BehaviorRelay<IBlock?>.init(value: nil)
    
    private let roomId: Int
    private let blockRepository: IBlockImmutableRepository
    private let mostRecentBlockUtility: IMostRecentBlockUtility
    
    private var mostRecentSessionBlock: IBlock? {
        let blocksSortedByDate = blockRepository.getBlocks(roomId: roomId)
        return mostRecentBlockUtility
            .getMostRecentSession(blocksSortedByDate: blocksSortedByDate)
    }
    
    init(roomId: Int, blockRepository: IBlockImmutableRepository, mostRecentBlockUtility: IMostRecentBlockUtility) {
        self.roomId = roomId
        self.blockRepository = blockRepository
        self.mostRecentBlockUtility = mostRecentBlockUtility
        bindOutput()
        bindAutomaticSession()
    }
    
    private func bindOutput() { // hook-up se za Realm, sada su Rooms synced sa bazom
        
        treba mi DATE da bih ga prosledio repo-u, koji ce ga ugraditi kao parametar da bi mi vratio [Section] -> dodaj ga kroz fabrike VC-u a on fabrici za viewmodel
        
        let sections = blockRepository.getObsBlockGroupedByDate(roomId: roomId, date: date) //hard-coded
        sections
            .subscribe(onNext: { (groups) in
                print("emituje se event SECTIONS, timestamp = \(Date.now)")
                let sections = groups.map { (blocks) -> SectionOfCustomData in
                    let groupName = blocks.first!.getStartsAt().toString(format: Date.shortDateFormatString)!
                    let items = blocks.map(BlockCustomDataItemFactory.make)
                    return SectionOfCustomData(header: groupName, items: items)
                }
                self.oSectionsHeadersAndItems.accept(sections)
            }).disposed(by: disposeBag)
    }
    
    // ako ima bilo koji session u zadatom Room, na koji se ceka krace od 2 sata, emituj SessionId; ako nema, emituj nil.
    private func bindAutomaticSession(interval: TimeInterval = MyTimeInterval.waitToMostRecentSession) {
        
        let sessionAvailable = autoSessionIsAvailable(inLessThan: interval)
        
        if sessionAvailable {
            //print("emitujem na oAutomaticSession: \(mostRecentSessionBlock!.getId())")
            oAutomaticSession.accept(mostRecentSessionBlock)
        } else {
            oAutomaticSession.accept(nil)
        }
         
    }
    
    private func autoSessionIsAvailable(inLessThan interval: TimeInterval) -> Bool { // implement me
        return mostRecentSessionBlock != nil
    }
    
    // API:
    func getItems(date: Date?) -> BehaviorRelay<[SectionOfCustomData]> {
        return self.oSectionsHeadersAndItems
    }
    
    func transform(indexPath: IndexPath) -> IBlock {
        let sections = blockRepository.getBlockGroupedByDate(roomId: roomId, date: Date.now) //hard-coded
        return sections[indexPath.section][indexPath.row]
    }
    
    //deinit { print("deinit/BlockViewModel is deinit") }
    
}

class BlockCustomDataItemFactory {
    static func make(block: IBlock) -> SectionOfCustomData.Item {
        let fullName = "implement me ???"
        return SectionOfCustomData.Item(fullname: fullName,
                                        name: block.getName(),
                                        date: block.getStartsAt())
    }
}
