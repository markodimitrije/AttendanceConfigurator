
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

class DelegatesAPIController {
    
    //  https://minjon.e-materials.com/data/delegates/7520.zip
    
    private let apiController: ApiController!
    
    struct Domain {
        static let baseUrl = URL(string: "https://service.e-materials.com/api")!
        static let minjonUrl = URL(string: "https://minjon.e-materials.com/")!
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
    
    //MARK: - API Calls
    func getDelegates() -> Observable<([Delegate])> {
   
        return apiController.buildRequest(base: Domain.minjonUrl,
                                          method: "GET",
                                          pathComponent: "data/delegates/7520.zip",
                                          params: [])
            .map{ data -> [Delegate] in
                print("data = \(data)")
                return ([ ])
            }
        
        
        
//            .map() { json in
//                let decoder = JSONDecoder()
//                guard let delegates = try? decoder.decode(Delegate.self, from: json) else {
//                    throw ApiError.invalidJson
//                }
//                return delegates
        
    }
    
    
}

struct Delegate: Codable {
//    var id: Int
//    var type: String
//    var email: String
    var code: String
//    var name: String?
//    var first_name: String
//    var last_name: String
//    var image_url: String
//    var image_url_thumb: String
//    var additional_info: String
//    var website: String
//    var conference_id: Int
//    var country_id: Int?
//    var user_id: Int?
//    var imported_id: Int?
//    var contact_info: String?
//    var updated_at: String
}



func unzipData() -> Observable<Data> {
    return Observable.create({ [weak self] (observer) -> Disposable in
        guard let strongSelf = self else { fatalError("Only works on live instance") }
        do {
            let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileName = "\(strongSelf.conferenceId).zip"
            let filePath = directoryURLs[0].appendingPathComponent(fileName)
            let unzipDirectory = try Zip.quickUnzipFile(filePath)
            let unzippedFilePath = unzipDirectory.appendingPathComponent("\(strongSelf.conferenceId).json")
            let string = try String(contentsOf: unzippedFilePath)
//            guard let response = ZipResponse(JSONString: string)
            guard let response = Data.init(base64Encoded: string)
                else { fatalError("Invalid structure") }
            try FileManager.default.removeItem(at: filePath)
            try FileManager.default.removeItem(at: unzippedFilePath)
            try FileManager.default.removeItem(at: unzipDirectory)
            response.deletePreviousState = true
            observer.onNext(response)
        } catch let err {
            observer.onError(err)
        }
        return Disposables.create()
    })
}
