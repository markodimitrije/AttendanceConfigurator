//
//  CodeReportsState.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/11/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//
import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import Realm

class CodeReportsStateFactory {
    static func make() -> CodeReportsState {
        let apiController = CodeReportApiControllerFactory.make()
        let repository = CodeReportsRepositoryFactory.make()
        return CodeReportsState(apiController: apiController, repository: repository)
    }
}

class CodeReportsState { // ovo je trebalo da zoves viewModel-om !
    
    private let apiController: ICodeReportApiController
    private let repository: ICodeReportsRepository
    init(apiController: ICodeReportApiController, repository: ICodeReportsRepository) {
        self.apiController = apiController
        self.repository = repository
        bindInputWithOutput()
    }
    
    private var codeReports: Results<RealmCodeReport>? {
        
        guard let realm = try? Realm.init() else {return nil} // ovde bi trebalo RealmError!
        
        return realm.objects(RealmCodeReport.self)
    }
    
    private var shouldReportToWeb: Bool {
        
        guard let reports = codeReports else {return false} // ovde bi trebalo RealmError!
        
        return reports.isEmpty
    }
    
    private var timer: Timer?
    
    private let bag = DisposeBag()
    
    // INPUT
    
    let codeReport = BehaviorRelay<CodeReport?>.init(value: nil)
    
    // OUTPUT
    
    let webNotified = BehaviorRelay<(CodeReport, Bool)?>.init(value: nil)
    
    private func bindInputWithOutput() { print("CodeReportsState.bindInputWithOutput")
        
        codeReport
            .asObservable()
            .subscribe(onNext: { [weak self] report in
                
                guard let sSelf = self else {return}
                let obs = sSelf.reportImidiatelly(codeReport: sSelf.codeReport.value)
                obs
                    .subscribe(onNext: { (code, success) in
                        
                        sSelf.webNotified.accept((code, success)) // postavi na svoj Output
                        
                        if success {
                            sSelf.repository.save(codesAcceptedFromWeb: [code])
                                .subscribe(onNext: { saved in
                                    print("code successfully reported to web, save in your archive")
                                }).disposed(by: sSelf.bag)
                        }
                        
                        if !success {
                            sSelf.codeReportFailed(code) // izmestac code
                        }
                        
                    })
                    .disposed(by: sSelf.bag)
            })
            .disposed(by: bag)
        
    }
    
    private func codeReportFailed(_ report: CodeReport) {
        
        print("codeReportFailed/ snimi ovaj report.code \(report.code) u realm")
        
        _ = repository.saveToRealm(codeReport: report)
        // okini process da javljas web-u sve sto ima u realm (codes)
        if codesDumper == nil {
            codesDumper = CodesDumperFactory.make() // u svom init, zna da javlja reports web-u...
            codesDumper.oCodesDumped
                .asObservable()
                .subscribe(onNext: { (success) in
                    if success {
                        codesDumper = nil
                    }
                })
                .disposed(by: bag)
        }
        
    }
    
    private func reportImidiatelly(codeReport: CodeReport?) -> Observable<(CodeReport, Bool)> {
        
        guard let report = codeReport else {return Observable.empty()}
        let codeReportApi = CodeReportApiControllerFactory.make()
        return codeReportApi.reportSingleCode(report: report)
    }
    
    // implement me...
    private func reportToWeb(codeReports: Results<RealmCodeReport>?) {
        
        // sviranje... treba mi servis da javi sve.... za sada posalji samo jedan...
        
        guard let report = codeReports?.first else {
            print("nemam ni jedan code da report!...")
            return
        }
        
        print("CodeReportsState/ javi web-u za ovaj report:")
        print("code = \(report.code)")
        print("code = \(report.date)")
        print("code = \(report.sessionId)")
    }
    
}
