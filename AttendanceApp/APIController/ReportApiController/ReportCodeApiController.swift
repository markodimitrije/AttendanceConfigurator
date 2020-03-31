//
//  ReportCodeApiController.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

// TODO marko -> only multiple codes should exist - remove single code report

protocol ICodeReportApiController {
    func reportSingleCode(report: CodeReport?) -> Observable<(CodeReport,Bool)> // TODO marko just ()
    func reportMultipleCodes(reports: [CodeReport]?) -> Observable<Bool> // isto...
}

class CodeReportApiController: ICodeReportApiController {
    
    static let baseTrackerURL = URL(string: "http://tracker.e-materials.com/")!
    
    private let apiController: ApiController
    init(apiController: ApiController) {
        self.apiController = apiController
    }
    
    func reportSingleCode(report: CodeReport?) -> Observable<(CodeReport,Bool)> {
            
        guard let report = report else {return Observable.empty()}
        
        let params = report.getPayload()
            
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
        
    func reportMultipleCodes(reports: [CodeReport]?) -> Observable<Bool> {
        
        guard let reports = reports else {return Observable.empty()}
        
        let params = CodeReport.getPayload(reports)
        
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

class CodeReportApiControllerFactory {
    static func make() -> ICodeReportApiController {
        return CodeReportApiController(apiController: ApiController.shared)
    }
}
