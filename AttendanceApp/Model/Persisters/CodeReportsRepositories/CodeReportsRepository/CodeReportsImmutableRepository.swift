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
            return self.getCountFor(predicate: NSPredicate(format: "campaignId == %@ && blockId == %i", campaignId, blockId))
        } else {
            return self.getCountFor(predicate: NSPredicate(format: "campaignId == %@", campaignId))
        }
    }
    
    func getApprovedScansCount() -> Int {
        self.getCountFor(predicate: NSPredicate(format: "campaignId == %@ && accepted = true", campaignId))
    }
    
    func getRejectedScansCount() -> Int {
        self.getCountFor(predicate: NSPredicate(format: "campaignId == %@ && accepted = false", campaignId))
    }
    
    func getSyncedScansCount() -> Int {
        self.getCountFor(predicate: NSPredicate(format: "campaignId == %@ && reported = true", campaignId))
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
            let reports = try genericRepo
                .getObjects(ofType: RealmCodeReport.self,
                            filter: NSPredicate(format: "campaignId == %@ && reported == false", campaignId),
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
        genericRepo
            .getObsObjects(ofType: RealmCodeReport.self,
                           filter: NSPredicate(format: "campaignId == %@ && reported == false", campaignId),
                           sortDescriptors: [SortDescriptor.dateNewestFirst])
        .map {$0.toArray().map(CodeReportFactory.make)}
    }
    
}

struct CodeReportsImmutableRepository {
    private let genericRepo: IGenRealmImmutableRepo
    private let campaignId: String
    init(genericRepo: IGenRealmImmutableRepo = GenRealmImmutableRepo(), campaignId: String) {
        self.genericRepo = genericRepo
        self.campaignId = campaignId
    }
}
