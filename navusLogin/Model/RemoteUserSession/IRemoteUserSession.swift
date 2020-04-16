//
//  IRemoteUserSession.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 11/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol IRemoteUserSession {
    func getCredentials() -> ILoginCredentials
    func getToken() -> String
}
