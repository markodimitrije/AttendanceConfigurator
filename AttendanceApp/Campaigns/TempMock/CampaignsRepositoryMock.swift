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
        return Observable.create { (observer) -> Disposable in
            observer.onNext(campaigns1)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

let campA = Campaign(name: "A", description: "descA")
let campB = Campaign(name: "B", description: "descB")
let campC = Campaign(name: "C", description: "descC")
let campD = Campaign(name: "D", description: "descD")
let campaigns1 = [campA, campB, campC]
let campaigns2 = [campA, campB]
let campaigns3 = [campA, campB, campD]
