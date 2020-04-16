//
//  LoginViewModel.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 10/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import RxSwift

class LoginViewModel: ILoginViewModel {
    
    private let validator: ILoginValidator
    private let loginWorker: ILoginWorker
    
    init(validator: ILoginValidator, loginWorker: ILoginWorker) {
        self.validator = validator
        self.loginWorker = loginWorker
    }
    
    func transform(input: Input) -> Output {
        
        let validationSignalFactory = LoginValidationSignalFactory(validator: self.validator)
        let validatedInput = validationSignalFactory.filterInput(userInput: input.userCredentials)
        
        let remoteSignalFactory = LoginRemoteSignalFactory(loginWorker: self.loginWorker)

        let loginRemoteSignal = remoteSignalFactory.createWith(sig: validatedInput)
                                                    .subscribeOn(MainScheduler.instance)
        return Output(loginSignal: loginRemoteSignal)
    }
    
}

class LoginWorkerFactory {
    static func make() -> ILoginWorker {
        LoginWorker(loginRemoteApi: LoginRemoteApiFactory.make(),
                    userState: UserStateRepository())
    }
}

class LoginRemoteApiFactory {
    static func make() -> ILoginRemoteApi {
        LoginRemoteApi(apiController: LeadLinkLoginRemoteAPI()) // TODO: marko
    }
}
