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
        
        makeObservableReport(dataAccess: dataAccess, monitor: self.monitor)
            .debounce(1.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { report in
                    
                print("AlertStateReporter.javi web-u ovaj report = \(report.description)")
                
                _ = webAPI.reportSelectedSession(report: report)
            })
            .disposed(by: bag)
    }
    
    private func makeObservableReport(dataAccess: DataAccess, monitor: AlertStateMonitor) -> Observable<SessionReport> {
        
        let obsRoomId = dataAccess.output.map {$0.0?.id ?? -1 }
        let obsBlockId = dataAccess.output.map {$0.1?.id ?? -1 }
        
        return Observable
            .combineLatest(obsRoomId,
                           obsBlockId,
                           monitor.deviceReport.appInForeground,
                           monitor.deviceReport.batteryLevel,
                           monitor.deviceReport.batteryState)
            .map(makeReport)
    }
    
    private func makeReport(reportInfo: (roomId: Int, blockId: Int, appInFg: Bool, batLevel: Int, batStatus: String)) -> SessionReport {
        
        return SessionReport(location_id: reportInfo.roomId,
                             block_id: reportInfo.blockId,
                             battery_level: reportInfo.batLevel,
                             battery_status: reportInfo.batStatus,
                             app_active: reportInfo.appInFg)
    }
    
    private let bag = DisposeBag()
}

/*
class SessionReportFactory {
    
    static func makeObservableReport(dataAccess: DataAccess, monitor: AlertStateMonitor) -> Observable<SessionReport> {
        
        let obsRoomId = dataAccess.output.map {$0.0?.id ?? -1 }
        let obsBlockId = dataAccess.output.map {$0.1?.id ?? -1 }
        
        return Observable
            .combineLatest(obsRoomId,
                           obsBlockId,
                           monitor.deviceReport.appInForeground,
                           monitor.deviceReport.batteryLevel,
                           monitor.deviceReport.batteryState)
            .map(Self.make)
    }
    
    private static func make(reportInfo: (roomId: Int, blockId: Int, appInFg: Bool, batLevel: Int, batStatus: String)) -> SessionReport {
        
        return SessionReport(location_id: reportInfo.roomId,
                             block_id: reportInfo.blockId,
                             battery_level: reportInfo.batLevel,
                             battery_status: reportInfo.batStatus,
                             app_active: reportInfo.appInFg)
    }
}
*/
