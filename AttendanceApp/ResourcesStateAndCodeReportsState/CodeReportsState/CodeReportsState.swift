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
//import RealmSwift

class CodeReportsState { // ovo je trebalo da zoves viewModel-om !
    
    private let apiController: ICodeReportApiController
    private let repository: ICodeReportsRepository
    init(apiController: ICodeReportApiController, repository: ICodeReportsRepository) {
        self.apiController = apiController
        self.repository = repository
        bindInputWithOutput()
    }
    
    private var timer: Timer?
    
    private let bag = DisposeBag()
    
    // INPUT
    
    //let codeReport = BehaviorRelay<ICodeReport?>.init(value: nil)
    let codeReport = PublishSubject<ICodeReport>()
    
    // OUTPUT
    
    let webNotified = BehaviorRelay<(ICodeReport, Bool)?>.init(value: nil)
    
    private func bindInputWithOutput() { print("CodeReportsState.bindInputWithOutput")
        
        codeReport
        .asObservable()
        .subscribe(onNext: { [weak self] report in
            
            guard let sSelf = self else {return}
            sSelf.repository.save(codeReport: report)
            .subscribe { (success) in
                sSelf.apiController.reportSingleCode(report: report)
                
                    .subscribe(onNext: { (report, success) in
                        if success {
                            _ = sSelf.repository.update(codesAcceptedFromWeb: [report])
                        } else {
                            sSelf.codeReportFailed(report)
                        }
                    })
                    .disposed(by: sSelf.bag)
            }.disposed(by: sSelf.bag)
        })
        .disposed(by: bag)
        
    }
    
    private func codeReportFailed(_ report: ICodeReport) {
        
        print("codeReportFailed, pokreni proces da javljas ovaj report.....")
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
}
