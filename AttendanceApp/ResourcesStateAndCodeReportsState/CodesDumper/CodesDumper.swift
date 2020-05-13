//
//  CodesDumper.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/11/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import Realm

class CodesDumper: ICodesDumperWorker {
    
    private let apiController: ICodeReportApiController
    private let repository: ICodeReportsRepository
    
    init(apiController: ICodeReportApiController, repository: ICodeReportsRepository) {
        self.apiController = apiController
        self.repository = repository
        self.codeReportsSynced = BehaviorRelay.init(value: repository.getCodeReports().isEmpty)
        print("CodesDumper.INIT, fire every 8 sec or on wi-fi changed")
        hookUpTimer()
        hookUpNotifyWeb()
        hookUpAllCodesReportedToWeb()
    }
    
    private let bag = DisposeBag.init()
    private var codeReportsSynced: BehaviorRelay<Bool>
    private var timer: Observable<Int>?
    private let isRunning = BehaviorRelay.init(value: false) // timer
    private let timerFired = BehaviorRelay.init(value: ()) // timer events
    
    private var timeToSendReport: Observable<Bool> {
        return timerFired
                    .asObservable()
                    //.map {return true} // temp ON
                    .withLatestFrom(connectedToInternet()) // temp OFF
    }
    
    // Output
    var oCodesDumped = BehaviorRelay<Bool>.init(value: false)
    
    // MARK:- Private methods
    
    private func hookUpTimer() {
        
        isRunning.asObservable()
            //.debug("isRunning")
            .flatMapLatest {  isRunning in
                isRunning ? Observable<Int>.interval(MyTimeInterval.sendScanReportsToWebEvery,
                                                     scheduler: MainScheduler.instance) : .empty()
            }
            .enumerated().flatMap { (int, index) in
                return Observable.just(index)
            }
            //.debug("timer")
            .subscribe({[weak self] _ in
                guard let sSelf = self else {return}
                sSelf.timerFired.accept(())
            })
            .disposed(by: bag)
        
        isRunning.accept(true) // one time pokreni timer
        
    }
    
    private func hookUpNotifyWeb() {
        
        timeToSendReport
            .subscribe(onNext: { [weak self] timeToReport in // print("timeToReport = \(timeToReport)")
                
                guard let sSelf = self else {return}
                
                let codeReports = sSelf.repository.getUnsynced()
                
                sSelf.reportSavedCodesToWeb(codeReports: codeReports)
                    .subscribe(onNext: { success in
                        if success {
                            
                            sSelf.repository.update(codesAcceptedFromWeb: codeReports)
                                .subscribe(onNext: { synced in
                                    print("reported codes synced with web = \(synced)")
                                    sSelf.codeReportsSynced.accept(synced)
                            }).disposed(by: sSelf.bag)
                            
                        } else {
                            print("nije success, nastavi da proveravas..")
                        }
                    })
                    .disposed(by: sSelf.bag)
            })
            .disposed(by: bag)
        
    }
    
    private func hookUpAllCodesReportedToWeb() {
        
        codeReportsSynced.asObservable()
            .subscribe(onNext: { [weak self] success in
                guard let sSelf = self else {return}
                if success { print("all good, ugasi timer!")
                    
                    sSelf.isRunning.accept(false)  // ugasi timer, uspesno si javio i obrisao Realm
                    sSelf.oCodesDumped.accept(true)
                }
            })
            .disposed(by: bag)
    }
    
    private func reportSavedCodesToWeb(codeReports: [ICodeReport]) -> Observable<Bool> { print("reportSavedCodesToWeb")
        
        guard !codeReports.isEmpty else { print("CodesDumper.reportSavedCodes/ internal error...")
            return Observable.just(false)
        }
        
        return
            self.apiController
            .reportMultipleCodes(reports: codeReports)
            .map({ (success) -> Bool in
                if success {
                    return true
                } else {
                    return false
                }
            })
    }
    
}
