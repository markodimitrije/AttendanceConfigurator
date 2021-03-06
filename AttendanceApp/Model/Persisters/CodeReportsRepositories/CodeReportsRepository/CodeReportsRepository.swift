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
    
    // MARK:- Get
    func getCodeReports() -> [ICodeReport] {
        return readRepo.getCodeReports()
    }

    func getUnsynced() -> [ICodeReport] {
        return readRepo.getUnsynced()
    }

    func getObsUnsynced() -> Observable<[ICodeReport]> {
        return readRepo.getObsUnsynced()
    }

    func getObsCodeReports() -> Observable<[ICodeReport]> {
        return readRepo.getObsCodeReports()
    }
 
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
    private let readRepo: ICodeReportsImmutableRepository
    private let writeRepo: ICodeReportsMutableRepository
    init(readRepo: ICodeReportsImmutableRepository, writeRepo: ICodeReportsMutableRepository) {
        self.readRepo = readRepo
        self.writeRepo = writeRepo
    }
}
