//
//  CodeReportsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

// this object is facade for read and write CodeReportsRepositories

extension CodeReportsRepository: ICodeReportsRepository {
    
    // MARK:- Query for count of
    func getTotalScansCount(blockId: Int?) -> Int { readRepo.getTotalScansCount(blockId: blockId) }
    
    func getApprovedScansCount() -> Int { readRepo.getApprovedScansCount() }
    
    func getRejectedScansCount() -> Int { readRepo.getRejectedScansCount()
    }
    
    func getSyncedScansCount() -> Int {
        readRepo.getSyncedScansCount()
    }
    
    // MARK:- Get
    func getCodeReports() -> [ICodeReport] { readRepo.getCodeReports() }

    func getUnsynced() -> [ICodeReport] { readRepo.getUnsynced() }

    func getObsUnsynced() -> Observable<[ICodeReport]> { readRepo.getObsUnsynced() }

    func getObsCodeReports() -> Observable<[ICodeReport]> { readRepo.getObsCodeReports() }
 
    // MARK:- Delete
    func deleteAllCodeReports() -> Observable<Bool> {
        return writeRepo.deleteAllCodeReports()
    }
    
    // MARK: Save, Update
    func save(codeReport: ICodeReport) -> Observable<Bool> {
        return writeRepo.save(codeReport: codeReport)
    }
    
    func update(codesAcceptedFromWeb codeReports: [ICodeReport]) -> Observable<Bool> {
        writeRepo.update(codesAcceptedFromWeb: codeReports)
    }

}

class CodeReportsRepository {
    private let readRepo: ICodeReportsQueryImmutableRepository
    private let writeRepo: ICodeReportsMutableRepository
    init(readRepo: ICodeReportsQueryImmutableRepository,
         writeRepo: ICodeReportsMutableRepository) {
        self.readRepo = readRepo
        self.writeRepo = writeRepo
    }
}
