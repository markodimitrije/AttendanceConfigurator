//
//  CodeReportsImmutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

extension CodeReportsImmutableRepository: ICodeReportsImmutableRepository {
    
    static var notSyncedPredicate = NSPredicate(format: "reported == false")
    
    func getCodeReports() -> [ICodeReport] {
        let realm = try! Realm()
        return realm.objects(RealmCodeReport.self).map(CodeReport.init)
    }
    
    func getUnsynced() -> [ICodeReport] {
        return self.getCodeReportResults(with: Self.notSyncedPredicate).map(CodeReport.init)
    }
    
    func getObsUnsynced() -> Observable<[ICodeReport]> {
        let unsynced = self.getCodeReportResults(with: Self.notSyncedPredicate)
        return obsReports(unsynced)
    }
    
    func getObsCodeReports() -> Observable<[ICodeReport]> {
        let rCodeReports = getAllCodeReportResults()
        return obsReports(rCodeReports)
    }
    
    // MARK:- Private
    private func obsReports(_ reports: Results<RealmCodeReport>) -> Observable<[ICodeReport]> {
        let obsRealmCodeReports = Observable.collection(from: reports)
        return obsRealmCodeReports.map { (results) -> [ICodeReport] in
            return results.map(CodeReportFactory.make)
        }
    }
    
    // MARK:- Fetch Results
    private func getCodeReportResults(with predicate: NSPredicate) -> Results<RealmCodeReport> {
        let realm = try! Realm()
        return realm.objects(RealmCodeReport.self)
                    .filter(predicate)
                    .sorted(byKeyPath: "date", ascending: false)
    }
    
    private func getAllCodeReportResults() -> Results<RealmCodeReport> {
        let realm = try! Realm()
        return realm.objects(RealmCodeReport.self)
                    .sorted(byKeyPath: "date", ascending: false)
    }
    
}

class CodeReportsImmutableRepository {}
