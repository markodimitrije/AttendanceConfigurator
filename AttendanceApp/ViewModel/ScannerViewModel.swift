//
//  ScannerViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 23/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ScannerViewModel {
    
    var dataAccess: DataAccess!
    private let roomRepo: IRoomRepository = RoomRepository() //TODO marko: inject through init
    
    init(dataAccess: DataAccess) {
        self.dataAccess = dataAccess
        bindOutput()
    }
    
    // OUTPUT
    var sessionName = PublishSubject<String>.init()
    var sessionInfo = PublishSubject<String>.init()

    private (set) var oSessionId = BehaviorRelay<Int>.init(value: -1) // err state
    
    var sessionId: Int {
        return oSessionId.value
    }
    
    private let bag = DisposeBag()
    
    private func bindOutput() {
    
        dataAccess.output
            .delay(0.05, scheduler: MainScheduler.instance) // HACK - ovaj signal emituje pre nego je izgradjen UI
            .map({ (roomId, block, date, _) -> (String, String, Int) in
                guard let roomId = roomId else {
                    return (RoomTextData.noRoomSelected, "", -1)
                }
                
                guard let block = block else {
                    return (SessionTextData.noActiveSession, "", -1)
                }
                let room = self.roomRepo.getRoom(id: roomId)!
                return (block.name, block.duration + ", " + room.getName(), block.id)
            })
            .subscribe(onNext: { (blockName, blockInfo, blockId) in
                self.sessionName.onNext(blockName)
                self.sessionInfo.onNext(blockInfo)
                self.oSessionId.accept(blockId)
            })
            .disposed(by: bag)
        
    }
    
}
