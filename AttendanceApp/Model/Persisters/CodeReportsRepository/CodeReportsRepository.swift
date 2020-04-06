//
//  CodeReportsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import RealmSwift

protocol ICodeReportsRepository {
    func getCodeReports() -> [ICodeReport]
    func getUnsynced() -> [ICodeReport]
    func getObsCodeReports() -> Observable<[ICodeReport]>
    func deleteAllCodeReports() -> Observable<Bool>
    func saveToRealm(codeReport: ICodeReport) -> Observable<Bool>
    func update(codesAcceptedFromWeb: [ICodeReport]) -> Observable<Bool>
}

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
    
    func getObsCodeReports() -> Observable<[ICodeReport]> {
        let realm = try! Realm()
        let rCodeReports = realm.objects(RealmCodeReport.self)
        let obsRealmCodeReports = Observable.collection(from: rCodeReports)
        return obsRealmCodeReports.map { (results) -> [ICodeReport] in
            let orderedByDate = results.toArray().sorted(by: >)
            return orderedByDate.map(CodeReportFactory.make)
        }
    }
    
    func saveToRealm(codeReport: ICodeReport) -> Observable<Bool> {
//        let rCodeReport = RealmCodeReportFactory.make(with: codeReport)
//        return self.genericRepo.saveToRealm(objects: [rCodeReport])
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        
        //let newCodeReport = RealmCodeReport.create(with: codeReport)
        let newCodeReport = RealmCodeReportFactory.make(with: codeReport)

        if realm.objects(RealmCodeReport.self).filter("code = %@ && sessionId = %@", codeReport.getCode(), codeReport.getSessionId()).isEmpty {
            
            do { // ako nemas ovaj objekat kod sebe u bazi
                
                try realm.write {
                    realm.add(newCodeReport)
                }
            } catch {
                return Observable<Bool>.just(false)
            }
        
        } else {
            print("CodeReportsRepository.saveToRealm.objekat, code = \(codeReport.getCode()), \(codeReport.getSessionId()) vec postoji u bazi")
        }
        
        return Observable<Bool>.just(true) // all good here
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
