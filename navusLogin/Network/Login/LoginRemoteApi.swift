//
//  LoginRemoteApi.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 11/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

class LoginRemoteApi: ILoginRemoteApi {

    private let apiController: ApiController
    private let networkResponseHandler: INetworkResponseHandler
    init(apiController: ApiController,
         networkResponseHandler: INetworkResponseHandler = NetworkResponseHandlerDefault()) {
        self.apiController = apiController
        self.networkResponseHandler = networkResponseHandler
    }
    
    func loginWith(sig: Observable<ILoginCredentials>) -> Observable<IRemoteUserSession> {
        sig.flatMap(self.logIn).observeOn(MainScheduler.instance)
    }
    
    private func logIn(credentials: ILoginCredentials) -> Observable<IRemoteUserSession> {
        
        let params = ["email":credentials.email, "password":credentials.password]
        
        return apiController
            .buildRequest(method: "POST",
                          pathComponent: "login",
                          params: params,
                          responseHandler: self.networkResponseHandler)
        .flatMap { (data) -> Observable<IRemoteUserSession> in
            return Observable.create { (observer) -> Disposable in
                
                do {
                    let decoder = JSONDecoder()
                    let payload = try decoder.decode(LoginResponsePayload.self, from: data)
                    let token = payload.data
                    let session = RemoteUserSessionFactory.make(credentials: credentials,
                                                                remoteToken: token)
                    observer.onNext(session)
                    observer.onCompleted()
                } catch {
                    observer.onError(LoginError.badParsing)
                }
                
                return Disposables.create()
            }
        }
    }
}

class RemoteUserSessionFactory {
    static func make(credentials: ILoginCredentials, remoteToken: SignInToken) -> IRemoteUserSession {
        return RemoteUserSession(credentials: credentials, token: remoteToken.token)
    }
}
