//
//  ReportCodeApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

class CodeReportApiController: ICodeReportApiController {
    
    static let baseTrackerURL = URL(string: "http://tracker.e-materials.com/")!
    
    private let apiController: ApiController
    init(apiController: ApiController) {
        self.apiController = apiController
    }
    
    func reportSingleCode(report: CodeReport) -> Observable<(CodeReport,Bool)> {
        
        let params = CodeReportsPayloadFactory.makeSinglePayload(report: report)
            
        return
            apiController
                .buildRequest(base: CodeReportApiController.baseTrackerURL,
                              method: "POST",
                              pathComponent: "attendances",
                              params: params,
                              contentType: "application/json")
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
        
    func reportMultipleCodes(reports: [CodeReport]) -> Observable<Bool> {
        
        let params = CodeReportsPayloadFactory.make(reports: reports)
        
        return
            apiController
                .buildRequest(base: CodeReportApiController.baseTrackerURL,
                                method: "POST",
                                pathComponent: "attendances",
                                params: params,
                                contentType: "application/json")
                .map() { data in
                    guard let object = try? JSONSerialization.jsonObject(with: data),
                        let json = object as? [String: Any],
                        let created = json["created"] as? Int, created == 201 else {
                        return false
                    }
                return true
        }
    }
}
