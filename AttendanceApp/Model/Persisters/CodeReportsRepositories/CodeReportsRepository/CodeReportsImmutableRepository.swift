//
//  CodeReportsImmutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

/*
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
*/

extension CodeReportsImmutableRepository: ICodeReportsQueryImmutableRepository {
    func getTotalScansCount(blockId: Int? = nil) -> Int {
        if let blockId = blockId {
            return self.getCountFor(predicate: NSPredicate(format: "blockId == %i", blockId))
        } else {
            return self.getCountFor(predicate: NSPredicate(format: "TRUEPREDICATE"))
        }
    }
    
    func getApprovedScansCount() -> Int {
        self.getCountFor(predicate: NSPredicate(format: "accepted = true"))
    }
    
    func getRejectedScansCount() -> Int {
        self.getCountFor(predicate: NSPredicate(format: "accepted = false"))
    }
    
    func getSyncedScansCount() -> Int {
        self.getCountFor(predicate: NSPredicate(format: "reported = true"))
    }
    
    private func getCountFor(predicate: NSPredicate) -> Int {
        do {
            return try genericRepo.getObjects(ofType: RealmCodeReport.self,
                                              filter: predicate).count
        } catch {
            return 0
        }
    }
    
    
    func getCodeReports() -> [ICodeReport] {
        do {
            let sortByDate = SortDescriptor.dateNewestFirst
            let reports = try genericRepo.getObjects(ofType: RealmCodeReport.self,
                                                     sortDescriptors: [sortByDate])
                .toArray()
                .map(CodeReportFactory.make)
            return reports
        } catch {
            return [ ]
        }
    }
    
    func getUnsynced() -> [ICodeReport] {
        do {
            let sortByDate = SortDescriptor.dateNewestFirst
            let reports = try genericRepo.getObjects(ofType: RealmCodeReport.self,
                                                     filter: NSPredicate(format: "reported == false"),
                                                     sortDescriptors: [sortByDate])
                .toArray()
                .map(CodeReportFactory.make)
            return reports
        } catch {
            return [ ]
        }
    }
    
    func getObsCodeReports() -> Observable<[ICodeReport]> {
        genericRepo.getObsObjects(ofType: RealmCodeReport.self,
                                  sortDescriptors: [SortDescriptor.dateNewestFirst])
            .map {$0.toArray().map(CodeReportFactory.make)}
    }
    
    func getObsUnsynced() -> Observable<[ICodeReport]> {
        genericRepo.getObsObjects(ofType: RealmCodeReport.self,
                                  filter: NSPredicate(format: "reported == false"),
                                  sortDescriptors: [SortDescriptor.dateNewestFirst])
        .map {$0.toArray().map(CodeReportFactory.make)}
    }
    
}

struct CodeReportsImmutableRepository {
    private let genericRepo: IGenRealmImmutableRepo
    init(genericRepo: IGenRealmImmutableRepo = GenRealmImmutableRepo()) {
        self.genericRepo = genericRepo
    }
}
