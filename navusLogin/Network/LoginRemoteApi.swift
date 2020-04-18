//
//  LoginRemoteApi.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 11/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

class LoginRemoteApi: ILoginRemoteApi {

    private let apiController: LeadLinkLoginRemoteAPI
    init(apiController: LeadLinkLoginRemoteAPI) {
        self.apiController = apiController
    }
    
    func loginWith(sig: Observable<ILoginCredentials>) -> Observable<IRemoteUserSession> {
        sig.flatMap(self.apiController.logIn).observeOn(MainScheduler.instance)
    }
}

class RemoteUserSessionFactory {
    static func make(credentials: ILoginCredentials, remoteToken: SignInToken) -> IRemoteUserSession {
        return RemoteUserSession(credentials: credentials, token: remoteToken.token)
    }
}




class LeadLinkLoginRemoteAPI {

    func logIn(credentials: ILoginCredentials) -> Observable<IRemoteUserSession> {
        
        let postData = NSMutableData(data: ")".data(using: String.Encoding.utf8)!)
        postData.append("&)".data(using: String.Encoding.utf8)!)
        
        let params = ["email":credentials.email, "password":credentials.password]
        
        return ApiController.shared
            .buildRequest(method: "POST", pathComponent: "login", params: params, responseHandler: LoginNetworkResponseHandler())
        .flatMap { (data) -> Observable<IRemoteUserSession> in
            return Observable.create { (observer) -> Disposable in
                
                do {
                    let decoder = JSONDecoder()
                    let payload = try decoder.decode(SignInResponsePayload.self, from: data)
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

struct SignInResponsePayload: Codable {
    var data: SignInToken
}

struct SignInToken: Codable {
    var token: String
}

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
