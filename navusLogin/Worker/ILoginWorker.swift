//
//  ILoginWorker.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

protocol ILoginWorker {
    func loginWith(input: Observable<ILoginCredentials>) -> Observable<IRemoteUserSession>
    func received(userSession: IRemoteUserSession)
}



