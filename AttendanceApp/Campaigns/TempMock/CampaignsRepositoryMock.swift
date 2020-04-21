//
//  CampaignsRepositoryMock.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 20/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

class CampaignsRepositoryMock: ICampaignsImmutableRepository {
    
    func getAll() -> Observable<[ICampaign]> {
        createDynamicObservable()
//        createStaticObservable()
    }
    
    private func createDynamicObservable() -> Observable<[ICampaign]> {
        return Observable<Int>.interval(RxTimeInterval(2), scheduler: MainScheduler.instance).map(CampaignsFactoryMock.getCampaigns)
    }
    
    private func createStaticObservable() -> Observable<[ICampaign]> {
        return Observable.create { (observer) -> Disposable in
            observer.onNext(campaigns1)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

class CampaignsFactoryMock {
    static func getCampaigns(value: Int) -> [ICampaign] {
        switch value {
        case value where (value % 3) == 0: return campaigns1
        case value where (value % 3) == 1: return campaigns2
        case value where (value % 3) == 2: return campaigns3
        default:
            fatalError()
        }
    }
}

let campA = Campaign(name: "A", description: "descA")
let campB = Campaign(name: "B", description: "descB")
let campC = Campaign(name: "C", description: "descC")
let campD = Campaign(name: "D", description: "descD")
let campaigns1: [ICampaign] = [campA, campB, campC]
let campaigns2: [ICampaign] = [campA, campB]
let campaigns3: [ICampaign] = [campA, campB, campD]
