//
//  DelegatesAPIController.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol IDelegatesAPIController {
 func getDelegates() -> Observable<([Delegate])>
}

class DelegatesAPIController {
 
 //  https://minjon.e-materials.com/data/delegates/7520.zip
 
    private let apiController: ApiController!
    private let unziper: IUnziper!
    private let bag = DisposeBag()
 
    struct Domain {
        static let baseUrl = URL(string: "https://service.e-materials.com/api")!
        static let minjonUrl = URL(string: "https://minjon.e-materials.com/")!
        static let baseLeadLinkURL = URL(string: "https://service.e-materials.com/api/leadlink/")!
//        static let baseUrl = URL(string: "https://b276c755-37f6-44d2-85af-6f3e654511ad.mock.pstmn.io")!
//        static let minjonUrl = URL(string: "https://b276c755-37f6-44d2-85af-6f3e654511ad.mock.pstmn.io")!
 }
 
    private var conferenceId: Int {
        return conferenceState.conferenceId ?? 0 // fatal
    }
 
    init(apiController: ApiController, unziper: IUnziper) {
     
        self.apiController = apiController
        self.unziper = unziper
        Logging.URLRequests = { request in return true }
    }

 // MOCK-API
 /*
 func getDelegates() -> Observable<([Delegate])> {
     
     return apiController.buildRequest(base: Domain.minjonUrl,
                                       method: "GET",
                                       pathComponent: "data/delegates/7520"
                                       )
         .flatMap(parseIntoDelegates)
 }
 
 private func parseIntoDelegates(data: Data) -> Observable<[Delegate]> {
     return Observable.create({ observer -> Disposable in
         
         let decoder = JSONDecoder.init()
         let result = try! decoder.decode(Delegates.self, from: data)
         let delegates = result.delegates
         observer.onNext(delegates)
         
         return Disposables.create()
     })
 }
*/
 //MARK: - API Calls
 
    func getDelegates() -> Observable<([Delegate])> {

        let unziper = Unziper.init(conferenceId: conferenceId)

        return
            apiController
                .buildRequest(base: Domain.minjonUrl,
                              method: "GET",
                              pathComponent: "data/delegates/" + "\(conferenceId)" + ".zip",
                              params: [])
                .flatMap(unziper.saveDataAsFile)
                .flatMap(unziper.unzipData)
                .flatMap(convert)
    }
    
    private func convert(data: Data) -> Observable<[Delegate]> {

        return Observable.create({(observer) -> Disposable in
            print("convert.data = \(data)")
            guard let delegatesStruct = try? JSONDecoder().decode(Delegates.self, from: data) else {
                observer.onNext([ ])
                return Disposables.create()
            }
            observer.onNext(delegatesStruct.delegates)
            return Disposables.create()
        })

    }
 
}
