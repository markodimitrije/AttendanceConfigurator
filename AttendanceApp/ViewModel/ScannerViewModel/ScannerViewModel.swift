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

extension ScannerViewModel: IScannerViewModel {
    func getScannerInfoDriver() -> SharedSequence<DriverSharingStrategy, IScannerInfo> {
        self.scannerInfoDriver
    }
    
    func getActualSessionId() -> Int {
        self.sessionId
    }
    
    func scannedCode(code: String, accepted: Bool) {
        let report = CodeReportFactory.make(code: code, sessionId: self.sessionId, date: Date.now, accepted: accepted)
        codeReportsState.codeReport.onNext(report)
    }
    
}

class ScannerViewModel {
    
    private var dataAccess: DataAccess!
    private let scannerInfoFactory: IScannerInfoFactory
    private let codeReportsState: CodeReportsState
    
    init(dataAccess: DataAccess, scannerInfoFactory: IScannerInfoFactory, codeReportsState: CodeReportsState) {
        self.dataAccess = dataAccess
        self.scannerInfoFactory = scannerInfoFactory
        self.codeReportsState = codeReportsState
        
        self.scannerInfoDriver = createOutput(dataAccess: dataAccess)
    }
    
    // OUTPUT
    
    private var _oSessionId = BehaviorRelay<Int>.init(value: -1) // err state
    var sessionId: Int {return _oSessionId.value}
    
    private (set) var scannerInfoDriver: SharedSequence<DriverSharingStrategy, IScannerInfo>!
    fileprivate let bag = DisposeBag()
    
    private func createOutput(dataAccess: DataAccess)
        -> SharedSequence<DriverSharingStrategy, IScannerInfo> {
            
        return dataAccess.output
            .delay(0.05, scheduler: MainScheduler.instance) // HACK - ovaj signal emituje pre nego je izgradjen UI
            .map { (roomId, blockId, _, _) -> IScannerInfo in
                return self.scannerInfoFactory.make(roomId: roomId, blockId: blockId)
            }.do(onNext: { scannerInfo in
                self._oSessionId.accept(scannerInfo.getBlockId())
            })
            .asDriver(onErrorJustReturn: ScannerInfo())
    }
}
