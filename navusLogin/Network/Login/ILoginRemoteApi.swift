//
//  ILoginRemoteApi.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 11/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

protocol ILoginRemoteApi {
    func loginWith(sig: Observable<ILoginCredentials>) -> Observable<IRemoteUserSession>
}
