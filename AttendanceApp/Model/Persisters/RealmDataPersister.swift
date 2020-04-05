//
//  RealmDataPersister.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 30/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

/* TODO marko: delete after claning on codeReportsRepository

import RxSwift
import RxCocoa
import RealmSwift
import Realm
import RxRealm

struct RealmDataPersister {
    
    static var shared = RealmDataPersister()
    
    // observable OUTPUT
    
    func getRealmWebReportedCodes() -> Observable<Results<RealmWebReportedCode>> {
        
        guard let realm = try? Realm.init() else {return Observable.empty()} // iako je Error!
        
        let results = realm.objects(RealmWebReportedCode.self)
        
        return Observable.collection(from: results) // this is live source !!
        
    }

    // MARK:- CodeReports
    
    func getCodeReports() -> [CodeReport] {
        
        guard let realm = try? Realm.init() else {return [ ]} // iako je Error!
        
        let realmResults = realm.objects(RealmCodeReport.self).toArray()
        
        return realmResults.map {CodeReport(realmCodeReport: $0)}
        
    }
    // transfered to dedaceted repository..
    func deleteAllCodeReports() -> Observable<Bool> {
        
        guard let realm = try? Realm.init() else {
            return Observable.just(false)
        } // iako je Error!
        
        let realmResults = realm.objects(RealmCodeReport.self)
        
        do {
            try realm.write {
                realm.delete(realmResults)
            }
//            print("RealmDataPersister.deleteAllCodeReports.all code reports are deleted")
            return Observable.just(true)
        } catch {
            return Observable.just(false)
        }
        
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
            print("RealmDataPersister.deleteCodeReports: delete Reported CodeReports")
            return Observable.just(true)
        } catch {
            return Observable.just(false)
        }
        
    }
    
    // MARK:- Save data
    // transfered to dedaceted repository..
    func saveToRealm(codeReport: ICodeReport) -> Observable<Bool> {
        
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
            print("saveToRealm.objekat, code = \(codeReport.getCode()), \(codeReport.getSessionId()) vec postoji u bazi")
        }
        
        return Observable<Bool>.just(true) // all good here
        
    }
    
    // MARK: save codes successfully reported to web
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
    
}

*/
