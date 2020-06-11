//
//  BlockViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 20/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RealmSwift
import RxSwift
import RxCocoa

protocol IBlockViewModel {
    func getItems() -> Observable<[BlocksSectionOfCustomData]>
    func transform(indexPath: IndexPath) -> IBlock
}

class BlockViewModel: IBlockViewModel {
    
    private let roomId: Int
    private let date: Date?
    private let blockRepository: IBlockImmutableRepository
    private let mostRecentBlockUtility: IMostRecentBlockUtility
    private let disposeBag = DisposeBag()
    
    private var mostRecentBlock: IBlock? {
        let blocksSortedByDate = blockRepository.getBlocks(roomId: roomId)
        return mostRecentBlockUtility
            .getMostRecentBlock(blocksSortedByDate: blocksSortedByDate)
    }
    
    // output:
    private var oSectionsHeadersAndItems = BehaviorRelay<[BlocksSectionOfCustomData]>.init(value: [])
    var oAutomaticBlock = BehaviorRelay<IBlock?>.init(value: nil)
    
    // API:
    func getItems() -> Observable<[BlocksSectionOfCustomData]> {
        return self.oSectionsHeadersAndItems.asObservable()
    }
    
    func transform(indexPath: IndexPath) -> IBlock {
        let sections = blockRepository.getBlockGroupedByDate(roomId: roomId, date: self.date)
        return sections[indexPath.section][indexPath.row]
    }
    
    init(roomId: Int, date: Date?, blockRepository: IBlockImmutableRepository, mostRecentBlockUtility: IMostRecentBlockUtility) {
        self.roomId = roomId
        self.date = date
        self.blockRepository = blockRepository
        self.mostRecentBlockUtility = mostRecentBlockUtility
        bindOutput()
        bindAutomaticBlock()
    }
    
    private func bindOutput() { // hook-up se za Realm, sada su Rooms synced sa bazom
        
        let sections = blockRepository.getObsBlockGroupedByDate(roomId: roomId, date: date)
        sections
            .subscribe(onNext: { (groups) in
                let sections = BlocksSectionOfCustomDataFactory.make(blockSections: groups,
                                                                     onDate: self.date)
                print("emitting sections with blocks!!")
                self.oSectionsHeadersAndItems.accept(sections)
            }).disposed(by: disposeBag)
    }
    
    private func bindAutomaticBlock() {
        
        if mostRecentBlock != nil {
            //print("emitujem na oAutomaticBlock: \(mostRecentBlock!.getId())")
            oAutomaticBlock.accept(mostRecentBlock)
        } else {
            oAutomaticBlock.accept(nil)
        }
         
    }
    //deinit { print("deinit/BlockViewModel is deinit") }
}
