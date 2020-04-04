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

class ScannerViewModel {
    
    private var dataAccess: DataAccess!
    private let scannerInfoFactory: IScannerInfoFactory
    
    init(dataAccess: DataAccess, scannerInfoFactory: IScannerInfoFactory) {
        self.dataAccess = dataAccess
        self.scannerInfoFactory = scannerInfoFactory
        self.scannerInfoDriver = createOutput(dataAccess: dataAccess)
    }
    
    // OUTPUT
    
    private (set) var oSessionId = BehaviorRelay<Int>.init(value: -1) // err state
    var sessionId: Int {return oSessionId.value}
    
    private (set) var oScannerInfo: BehaviorRelay<IScannerInfo>!
    
    
    
    private (set) var scannerInfoDriver: SharedSequence<DriverSharingStrategy, IScannerInfo>!
    private let bag = DisposeBag()
    
    private func createOutput(dataAccess: DataAccess)
        -> SharedSequence<DriverSharingStrategy, IScannerInfo>{
            
        return dataAccess.output
            .delay(0.05, scheduler: MainScheduler.instance) // HACK - ovaj signal emituje pre nego je izgradjen UI
            .map { (roomId, blockId, _, _) -> IScannerInfo in
                return self.scannerInfoFactory.make(roomId: roomId, blockId: blockId)
            }.do(onNext: { scannerInfo in
                self.oSessionId.accept(scannerInfo.getBlockId())
            })
            .asDriver(onErrorJustReturn: ScannerInfo())
    }
}
