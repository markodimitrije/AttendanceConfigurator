//
//  LoginNetworkResponseHandler.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 18/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

class LoginNetworkResponseHandler: INetworkResponseHandler {
    func handle(response: HTTPURLResponse, data: Data) throws -> Data {
        
        if response.statusCode == 401 {
            throw LoginError.unauthorized
        }
        
        if response.statusCode == 422 {
            throw LoginError.unprocessableEntity
        }

        guard 200..<300 ~= response.statusCode else {
            throw LoginError.httpError
        }
        return data
    }
}
