//
//  DefaultHeadersFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

let API_KEY = "Kx8YQFIFvC0VJK7xU5p8hOVVF5hHPO6T"

class DefaultHeadersCreator {
    private let userState: IUserStateRepository
    init(userState: IUserStateRepository) {
        self.userState = userState
    }
    func createHeaders(contentType: String = "application/json", apiKey: String? = API_KEY) -> [String: String] {
        let deviceUdid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        var headers = ["device-id": deviceUdid,
                       "Content-Type": contentType]
        if userState.getToken().token != "" {
            headers["Authorization"] = "Bearer " + userState.getToken().token
        }
        if apiKey != nil {
            headers["ApiKey"] = apiKey
        }
        return headers
    }
}

class DefaultHeadersFactory {
    static func make() -> DefaultHeadersCreator {
        DefaultHeadersCreator(userState: UserStateRepository())
    }
}
