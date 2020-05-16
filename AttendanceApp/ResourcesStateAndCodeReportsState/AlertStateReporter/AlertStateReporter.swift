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
    let webAPI: IReportBlockApiController
    
    init(dataAccess: CampaignSettingsRepository, monitor: AlertStateMonitor, webAPI: IReportBlockApiController) {
        
        self.monitor = monitor
        self.webAPI = webAPI
        
        makeObsBlockReport(dataAccess: dataAccess, monitor: self.monitor)
            .debounce(1.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { report in
                    
//                print("AlertStateReporter.javi web-u ovaj report = \(report.description)")
                
                _ = webAPI.reportSelected(report: report)
            })
            .disposed(by: bag)
    }
    
    private func makeObsBlockReport(dataAccess: CampaignSettingsRepository, monitor: AlertStateMonitor) -> Observable<BlockReport> {
        
        let obsRoomId = dataAccess.output.map {$0.0 ?? -1 }
        let obsBlockId = dataAccess.output.map {$0.1 ?? -1 }
        
        return Observable
            .combineLatest(obsRoomId,
                           obsBlockId,
                           monitor.deviceReport.appInForeground,
                           monitor.deviceReport.batteryLevel,
                           monitor.deviceReport.batteryState)
            .map(makeReport)
    }
    
    private func makeReport(reportInfo: (roomId: Int, blockId: Int, appInFg: Bool, batLevel: Int, batStatus: String)) -> BlockReport {
        
        return BlockReport(location_id: reportInfo.roomId,
                             block_id: reportInfo.blockId,
                             battery_level: reportInfo.batLevel,
                             battery_status: reportInfo.batStatus,
                             app_active: reportInfo.appInFg)
    }
    
    private let bag = DisposeBag()
}
