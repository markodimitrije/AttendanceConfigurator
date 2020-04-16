//
//  LoginViewModelInputFactory.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 14/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewModelInputFactory {
    static func make(emailField: UITextField, passField: UITextField, btn: UIButton) -> LoginViewModel.Input {
        let btnSig = btn.rx.tap.asObservable()
        let emailSig = emailField.rx.text.asObservable().map {$0 ?? ""}
        let passSig = passField.rx.text.asObservable().map {$0 ?? ""}
        let credentialsSig = Observable.combineLatest(emailSig, passSig) {
            LoginCredentials(email: $0, password: $1)
        }
        let inputSig = btnSig.withLatestFrom(credentialsSig).map {$0 as ILoginCredentials}.take(1)
        return LoginViewModel.Input(userCredentials: inputSig)
    }
}
