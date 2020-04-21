//
//  NetworkResponseHandlerDefault.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class NetworkResponseHandlerDefault: INetworkResponseHandler {
    
    func handle(response: HTTPURLResponse, data: Data) throws -> Data {
        
        if 201 == response.statusCode {
            return try! JSONSerialization.data(withJSONObject:  ["created": 201])
        } else if 200 ..< 300 ~= response.statusCode {
            return data
        } else if response.statusCode == 401 {
            throw ApiError.unauthorized
        } else if 400 ..< 500 ~= response.statusCode {
            throw ApiError.badRequest
        } else {
            throw ApiError.serverFailure
        }
    }
    
}
