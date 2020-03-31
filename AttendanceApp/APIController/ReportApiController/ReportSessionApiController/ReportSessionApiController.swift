//
//  ReportSelectedSessionApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

class ReportSessionApiController: IReportSessionApiController {
    static let baseTrackerURL = URL(string: "http://tracker.e-materials.com/")!
    private let apiController: IApiController
    init(apiController: IApiController) {
        self.apiController = apiController
    }
    
    func reportSelectedSession(report: SessionReport?) -> Observable<(SessionReport,Bool)> {
        guard let report = report else {return Observable.empty()}
        
        let params = report.getPayload()
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        return apiController
            .buildRequest(base: ReportSessionApiController.baseTrackerURL,
                method: "PUT",
                pathComponent: "devices/\(deviceId)",
                params: params,
                contentType: "text/plain")
            .map { data in
                guard let object = try? JSONSerialization.jsonObject(with: data),
                    let json = object as? [String: Any],
                    let created = json["created"] as? Int, created == 201 else {
                        return (report, false)
                }
                return (report, true)
            }
            .catchErrorJustReturn((report, false))
    }
}
