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

        return Observable<IRemoteUserSession>.create { observer in
            // Build Request
            var request = URLRequest(url: URL(string: "https://service.e-materials.com/api/login")!)
            request.httpMethod = "POST"

            let headers = [ // Build Auth Header
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache"
            ]

            let postData = NSMutableData(data: "email=\(credentials.email)".data(using: String.Encoding.utf8)!)
            postData.append("&password=\(credentials.password)".data(using: String.Encoding.utf8)!)

            request.httpBody = postData as Data
            request.allHTTPHeaderFields = headers

            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    observer.onError(LoginError.httpError)
                    return
                }
                guard 401 != httpResponse.statusCode else {
                    observer.onError(LoginError.unauthorized)
                    return
                }
                guard 422 != httpResponse.statusCode else { //
                    observer.onError(LoginError.unprocessableEntity)
                    return
                }

                guard 200..<300 ~= httpResponse.statusCode else {
                    observer.onError(LoginError.httpError)
                    return
                }

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

            }.resume()

            return Disposables.create()
        }
    }
}

struct SignInResponsePayload: Codable {
    var data: SignInToken
}

struct SignInToken: Codable {
    var token: String
}

