
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
import SwiftyJSON
import CoreLocation
import MapKit
import Reachability
import Zip

class DelegatesAPIController {
    
    //  https://minjon.e-materials.com/data/delegates/7520.zip
    
    private let apiController: ApiController!
    private let bag = DisposeBag()
    
    struct Domain {
        //static let baseUrl = URL(string: "https://service.e-materials.com/api")! hard-coded
        static let baseUrl = URL(string: "https://b276c755-37f6-44d2-85af-6f3e654511ad.mock.pstmn.io")!
//        static let minjonUrl = URL(string: "https://minjon.e-materials.com/")!
        static let minjonUrl = URL(string: "https://b276c755-37f6-44d2-85af-6f3e654511ad.mock.pstmn.io")!
        static let baseLeadLinkURL = URL(string: "https://service.e-materials.com/api/leadlink/")!
    }
    
    /// The shared instance
    static var shared = DelegatesAPIController(apiController: ApiController.init())
    
    init(apiController: ApiController) {
        self.apiController = apiController
        Logging.URLRequests = { request in // iz RxCocoa
            return true
        }
    }

    // MOCK-API
    
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
 
    //MARK: - API Calls
    /*
    func getDelegates() -> Observable<([Delegate])> {

        let unziper = Unziper.init(conferenceId: 7520)

        return apiController.buildRequest(base: Domain.minjonUrl,
                                          method: "GET",
                                          pathComponent: "data/delegates/7520.zip",
                                          params: [])
            .flatMap(unziper.saveDataAsFile)
            .flatMap(unziper.unzipData)
            .flatMap(convert)
    }

    private func convert(data: Data) -> Observable<[Delegate]> {

        return Observable.create({ [weak self] (observer) -> Disposable in
            print("convert.data = \(data)")
            guard let delegatesStruct = try? JSONDecoder().decode(Delegates.self, from: data) else {
                observer.onNext([ ])
                return Disposables.create()
            }
            observer.onNext(delegatesStruct.delegates)
            print(" my delegates struct = \(delegatesStruct.delegates)")
            return Disposables.create()
        })

    }
    */
}

class Unziper: NSObject {
    var conferenceId: Int
    init(conferenceId: Int) {
        self.conferenceId = conferenceId
    }
    
    func saveDataAsFile(data: Data) -> Observable<Bool> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let strongSelf = self else { fatalError("Only works on live instance") }
            do {
                let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let fileName = "\(strongSelf.conferenceId).zip"
                let filePath = directoryURLs[0].appendingPathComponent(fileName)
                try data.write(to: filePath)
                observer.onNext(true)
            } catch {
                observer.onNext(false)
            }
            return Disposables.create()
        })
    }
    
    func unzipData(success: Bool) -> Observable<Data> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let strongSelf = self else { fatalError("Only works on live instance") }
            
            do {
                let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let fileName = "\(strongSelf.conferenceId).zip"
                let filePath = directoryURLs[0].appendingPathComponent(fileName)
                let unzipDirectory = try Zip.quickUnzipFile(filePath)
                let unzippedFilePath = unzipDirectory.appendingPathComponent("\(strongSelf.conferenceId).json")
                //let string = try String(contentsOf: unzippedFilePath)
                guard let data = try? Data.init(contentsOf: unzippedFilePath) else {
                    fatalError("cant get data from zip")
                }
                
                try FileManager.default.removeItem(at: filePath)
                try FileManager.default.removeItem(at: unzippedFilePath)
                try FileManager.default.removeItem(at: unzipDirectory)
                observer.onNext(data)
            } catch let err {
                observer.onError(err)
            }
            return Disposables.create()
        })
    }
}


