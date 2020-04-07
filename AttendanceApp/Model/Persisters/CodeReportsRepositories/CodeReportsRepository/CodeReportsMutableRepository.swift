//
//  CodeReportsMutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

extension CodeReportsMutableRepository: ICodeReportsMutableRepository {
    
    // MARK: Delete
    func deleteAllCodeReports() -> Observable<Bool> {
        return genericRepo.deleteAllObjects(ofTypes: [RealmCodeReport.self])
    }
    
    // MARK: Save, Update
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

class CodeReportsMutableRepository {
    private let genericRepo: IGenericRealmRepository
    init(genericRepo: IGenericRealmRepository) {
        self.genericRepo = genericRepo
    }
}
