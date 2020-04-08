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
    func getItems() -> Observable<[SectionOfCustomData]>
    func transform(indexPath: IndexPath) -> IBlock
}

class BlockViewModel: IBlockViewModel {
    
    private let roomId: Int
    private let date: Date?
    private let blockRepository: IBlockImmutableRepository
    private let mostRecentBlockUtility: IMostRecentBlockUtility
    private let disposeBag = DisposeBag()
    
    private var mostRecentSessionBlock: IBlock? {
        let blocksSortedByDate = blockRepository.getBlocks(roomId: roomId)
        return mostRecentBlockUtility
            .getMostRecentSession(blocksSortedByDate: blocksSortedByDate)
    }
    
    // output:
    private var oSectionsHeadersAndItems = BehaviorRelay<[SectionOfCustomData]>.init(value: [])
    var oAutomaticSession = BehaviorRelay<IBlock?>.init(value: nil)
    
    // API:
    func getItems() -> Observable<[SectionOfCustomData]> {
        return self.oSectionsHeadersAndItems.asObservable()
    }
    
    func transform(indexPath: IndexPath) -> IBlock {
        let sections = blockRepository.getBlockGroupedByDate(roomId: roomId, date: self.date) //hard-coded
        return sections[indexPath.section][indexPath.row]
    }
    
    init(roomId: Int, date: Date?, blockRepository: IBlockImmutableRepository, mostRecentBlockUtility: IMostRecentBlockUtility) {
        self.roomId = roomId
        self.date = date
        self.blockRepository = blockRepository
        self.mostRecentBlockUtility = mostRecentBlockUtility
        bindOutput()
        bindAutomaticSession()
    }
    
    private func bindOutput() { // hook-up se za Realm, sada su Rooms synced sa bazom
        
        let sections = blockRepository.getObsBlockGroupedByDate(roomId: roomId, date: date) //hard-coded
        sections
            .subscribe(onNext: { (groups) in
                let sections = BlockSectionsOfCustomDataFactory.make(blockSections: groups,
                                                                     onDate: self.date)
                self.oSectionsHeadersAndItems.accept(sections)
            }).disposed(by: disposeBag)
    }
    
    private func bindAutomaticSession() {
        
        if mostRecentSessionBlock != nil {
            //print("emitujem na oAutomaticSession: \(mostRecentSessionBlock!.getId())")
            oAutomaticSession.accept(mostRecentSessionBlock)
        } else {
            oAutomaticSession.accept(nil)
        }
         
    }
    
    //deinit { print("deinit/BlockViewModel is deinit") }
    
}
