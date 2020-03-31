//
//  AlertStateReporter.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 28/11/2018.
//  Copyright © 2018 Navus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlertStateReporter {
    
    let monitor: AlertStateMonitor
    let webAPI: IReportSessionApiController
    
    init(dataAccess: DataAccess, monitor: AlertStateMonitor, webAPI: IReportSessionApiController) {
        
        self.monitor = monitor
        self.webAPI = webAPI
        
        let obsRoomId = dataAccess.output.map {$0.0?.id ?? -1 }
        let obsBlockId = dataAccess.output.map {$0.1?.id ?? -1 }
        
        Observable.combineLatest(obsRoomId,
                                 obsBlockId,
                                 monitor.deviceReport.appInForeground,
                                 monitor.deviceReport.batteryLevel,
                                 monitor.deviceReport.batteryState) {
                                    
            (roomId, blockId, appInFg, batLevel, batStatus) -> SessionReport in
            
                return SessionReport.init(location_id: roomId, block_id: blockId, battery_level: batLevel, battery_status: batStatus, app_active: appInFg)
            }
        .debounce(1.0, scheduler: MainScheduler.instance)
        .subscribe(onNext: { report in
                
                print("AlertStateReporter.javi web-u ovaj report = \(report.description)")
                
                _ = webAPI.reportSelectedSession(report: report)
            })
            .disposed(by: bag)
    }
    
    private let bag = DisposeBag()
}
