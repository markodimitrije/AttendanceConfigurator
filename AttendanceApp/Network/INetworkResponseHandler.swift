//
//  INetworkResponseHandler.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 18/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol INetworkResponseHandler {
    func handle(response: HTTPURLResponse, data: Data) throws -> Data
}
