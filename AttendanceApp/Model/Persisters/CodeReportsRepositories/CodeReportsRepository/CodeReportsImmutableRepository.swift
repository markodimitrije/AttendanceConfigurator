//
//  CodeReportsImmutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

extension CodeReportsImmutableRepository: ICodeReportsQueryImmutableRepository {
    func getTotalScansCount(blockId: Int? = nil) -> Int {
        if let blockId = blockId {
            return self.getCountFor(predicate: NSPredicate(format: "blockId == %i", blockId))
        } else {
            return self.getCountFor(predicate: NSPredicate.truePredicate)
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
