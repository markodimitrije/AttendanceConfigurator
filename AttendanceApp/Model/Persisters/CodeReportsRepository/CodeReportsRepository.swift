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
    func deleteAllCodeReports() -> Observable<Bool>
    func getCodeReports() -> [CodeReport]
    func saveToRealm(codeReport: ICodeReport) -> Observable<Bool>
    func save(codesAcceptedFromWeb: [CodeReport]) -> Observable<Bool>
    func deleteCodeReports(_ codeReports: [CodeReport]) -> Observable<Bool> //TODO: to delete...
}

extension CodeReportsRepository: ICodeReportsRepository {
    func deleteAllCodeReports() -> Observable<Bool> {
        return genericRepo.deleteAllObjects(ofTypes: [RealmCodeReport.self])
    }
    func getCodeReports() -> [CodeReport] {
        let realm = try! Realm()
        return realm.objects(RealmCodeReport.self).map(CodeReport.init)
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
    
    func save(codesAcceptedFromWeb: [CodeReport]) -> Observable<Bool> {
        
        guard let realm = try? Realm() else {
            return Observable<Bool>.just(false) // treba da imas err za Realm...
        }
        
        let firstAvailableId = realm.objects(RealmWebReportedCode.self).count
        let realmWebReportedCodes = codesAcceptedFromWeb.enumerated().map { (offset, codeReport) -> RealmWebReportedCode in
            let record = RealmWebReportedCode.create(id: firstAvailableId + offset, codeReport: codeReport)
            return record
        }
        
        do {
            try realm.write {
                realm.add(realmWebReportedCodes)
                print("total count of realmWebReportedCodes = \(realmWebReportedCodes.count), saved to realm")
            }
        } catch {
            return Observable<Bool>.just(false)
        }
        
        return Observable<Bool>.just(true) // all good here
        
    }
    
    func deleteCodeReports(_ codeReports: [CodeReport]) -> Observable<Bool> {
        
        guard let realm = try? Realm.init() else {
            return Observable.just(false)
        } // iako je Error!
        
        let realmResults = realm.objects(RealmCodeReport.self).filter { report -> Bool in
            return codeReports.map {$0.code}.contains(report.code)
        }
        
        do {
            try realm.write {
                realm.delete(realmResults)
            }
            print("CodeReportsRepository.deleteCodeReports: delete Reported CodeReports")
            return Observable.just(true)
        } catch {
            return Observable.just(false)
        }
        
    }
}

class CodeReportsRepository {
    private let genericRepo: IGenericRealmRepository
    init(genericRepo: IGenericRealmRepository) {
        self.genericRepo = genericRepo
    }
}
