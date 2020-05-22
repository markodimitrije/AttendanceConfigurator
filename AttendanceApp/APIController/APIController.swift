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
    }
    
    /// The shared instance
    static var shared = ApiController()
    
    init() {
        Logging.URLRequests = { request in return false }
    }
    
    func buildRequest(base: URL = Domain.baseUrl,
                      method: String = "GET",
                      pathComponent: String = "",
                      params: Any = [],
                      contentType: String? = "application/json",
                      headers: [String: String] = DefaultHeadersFactory.make().createHeaders(),
                      responseHandler: INetworkResponseHandler = NetworkResponseHandlerDefault()) -> Observable<Data> {
    
        let url = (pathComponent != "") ? base.appendingPathComponent(pathComponent) : base
        
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
