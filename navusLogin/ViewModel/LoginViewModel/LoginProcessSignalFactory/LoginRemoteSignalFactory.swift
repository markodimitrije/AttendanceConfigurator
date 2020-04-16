//
//  LoginRemoteSignalFactory.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 11/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

class LoginRemoteSignalFactory {
    
    private let loginWorker: ILoginWorker
    init(loginWorker: ILoginWorker) {
        self.loginWorker = loginWorker
    }
    
    func createWith(sig: Observable<ILoginCredentials>) -> Observable<Void> {
        return loginWorker.loginWith(input: sig).do(onNext: { (session) in
            self.loginWorker.received(userSession: session)
        }).map({_ in return ()})
    }
    
}
