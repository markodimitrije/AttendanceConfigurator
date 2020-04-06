//
//  CodeReportsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

extension CodeReportsRepository: ICodeReportsRepository {
    func deleteAllCodeReports() -> Observable<Bool> {
        return genericRepo.deleteAllObjects(ofTypes: [RealmCodeReport.self])
    }
    
    func getCodeReports() -> [ICodeReport] {
        let realm = try! Realm()
        return realm.objects(RealmCodeReport.self).map(CodeReport.init)
    }
    
    func getUnsynced() -> [ICodeReport] {
        let realm = try! Realm()
        return realm.objects(RealmCodeReport.self).filter("reported == false").map(CodeReport.init)
    }
    
    func getObsUnsynced() -> Observable<[ICodeReport]> {
        let realm = try! Realm()
        let unsynced = realm.objects(RealmCodeReport.self).filter("reported == false")
        return obsReports(unsynced)
    }
    
    func getObsCodeReports() -> Observable<[ICodeReport]> {
        let realm = try! Realm()
        let rCodeReports = realm.objects(RealmCodeReport.self)
        return obsReports(rCodeReports)
    }
    
    private func obsReports(_ reports: Results<RealmCodeReport>) -> Observable<[ICodeReport]> {
        let obsRealmCodeReports = Observable.collection(from: reports)
        return obsRealmCodeReports.map { (results) -> [ICodeReport] in
            let orderedByDate = results.toArray().sorted(by: >)
            return orderedByDate.map(CodeReportFactory.make)
        }
    }
    
    func save(codeReport: ICodeReport) -> Observable<Bool> {
        let rCodeReport = RealmCodeReportFactory.make(with: codeReport)
        return self.genericRepo.saveToRealm(objects: [rCodeReport])
    }
    
    func update(codesAcceptedFromWeb codeReports: [ICodeReport]) -> Observable<Bool> {
        
        let realmCodeReports = codeReports.map(RealmCodeReportFactory.make)
        _ = realmCodeReports.map {$0.reported = true}
        
        return genericRepo.saveToRealm(objects: realmCodeReports)
    }
    
}

class CodeReportsRepository {
    private let genericRepo: IGenericRealmRepository
    init(genericRepo: IGenericRealmRepository) {
        self.genericRepo = genericRepo
    }
}
