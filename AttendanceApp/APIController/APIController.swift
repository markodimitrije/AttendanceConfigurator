//
//  APIController.swift
//  tryObservableWebApiAndRealm
//
//  Created by Marko Dimitrijevic on 19/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol IApiController {
    func buildRequest(base: URL, method: String, pathComponent: String, params: Any, contentType: String?, headers: [String: String], responseHandler: INetworkResponseHandler) -> Observable<Data>
}

class ApiController: IApiController {
    
    struct Domain {
        static let baseUrl = URL(string: "https://service.e-materials.com/api")!
        static let minjonUrl = URL(string: "https://minjon.e-materials.com/api")!
        static let baseTrackerURL = URL(string: "http://tracker.e-materials.com/")!
        static let resourcesBaseUrl = URL(string: "https://service.e-materials.com/api/conferences/")!
    }
    
    /// The shared instance
    static var shared = ApiController()
    
    /// The api key to communicate with Navus
    private var apiKey: String {
        return conferenceState.apiKey ?? "fatal"
    }
    
    init() {
        Logging.URLRequests = { request in return true }
    }
    
    // MARK: - Api Key Sync
    func getApiKey() -> Observable<String?> {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let pathComponent = "devices" + "/" + deviceId
        return buildRequest(base: Domain.baseTrackerURL,
//        return buildRequest(base: Domain.mockURL,
                            method: "GET",
                            pathComponent: pathComponent,
                            params: [],
                            headers: [:], // hard-coded
                            responseHandler: NetworkResponseHandlerDefault())
            .map() { data in
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data),
                    let json = jsonObject as? [String: Any] else {return nil}
                print("vracam api_key = \(String(describing: json["api_key"] as? String))")
                return json["api_key"] as? String
            }
    }
    
    func buildRequest(base: URL = Domain.baseUrl,
                      method: String = "GET",
                      pathComponent: String,
                      params: Any = [],
                      contentType: String? = "application/json",
                      headers: [String: String] = DefaultHeadersFactory.make(),
                      responseHandler: INetworkResponseHandler = NetworkResponseHandlerDefault()) -> Observable<Data> {
    
        let url = base.appendingPathComponent(pathComponent)
        
        var request = URLRequest(url: url)
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        if method == "GET" || method == "PUT" {
            guard let params = params as? [(String, String)] else { // hard-coded off !!!
                return Observable.empty()
            }
            let queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
            urlComponents.queryItems = queryItems
        } else {
            if let params = params as? [String: Any] {
                let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                request.httpBody = jsonData
            }
        }
        
        request.url = urlComponents.url!
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        return session.rx.response(request: request).map() { arg in
            return try responseHandler.handle(response: arg.response, data: arg.data)
        }
    }
    
}

enum ApiError: Error {
    case invalidJson
    case invalidKey
    case badRequest
    case serverFailure
}

class NetworkResponseHandlerDefault: INetworkResponseHandler {
    
    func handle(response: HTTPURLResponse, data: Data) throws -> Data {
        
        if 201 == response.statusCode {
            return try! JSONSerialization.data(withJSONObject:  ["created": 201])
        } else if 200 ..< 300 ~= response.statusCode {
            return data
        } else if response.statusCode == 401 {
            throw ApiError.invalidKey
        } else if 400 ..< 500 ~= response.statusCode {
            throw ApiError.badRequest
        } else {
            throw ApiError.serverFailure
        }
    }
    
}

class DefaultHeadersFactory {
    static func make(contentType: String = "application/json") -> [String: String] {
        let deviceUdid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let apiKey = conferenceState.apiKey ?? ""
        return ["Api-Key": apiKey,
                "device-id": deviceUdid,
                "Content-Type": contentType]
    }
}
