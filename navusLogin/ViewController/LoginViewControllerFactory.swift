//
//  LoginViewControllerFactory.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 10/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class LoginViewControllerFactory {
    static func make() -> LoginViewController {
        let loginVC = StoryboardedViewControllerFactory.make(type: LoginViewController.self) as! LoginViewController
        loginVC.viewModel = LoginViewModelFactory.make()
        loginVC.alertErrPresenter = AlertErrorPresenter()
        loginVC.keyboardListener = KeyboardListener()
        return loginVC
    }
}

class LoginViewModelFactory {
    static func make() -> LoginViewModel {
        return LoginViewModel(validator: LoginValidatorFactory.make(),
                              loginWorker: LoginWorkerFactory.make())
    }
}

class StoryboardedViewControllerFactory {
    static func make(type: Storyboarded.Type) -> Storyboarded {
        let name = String(describing: type)
        var sb: UIStoryboard!
        if UIDevice.current.userInterfaceIdiom == .phone {
            sb = UIStoryboard.init(name: name, bundle: nil)
        } else {
            sb = UIStoryboard.init(name: name + "_iPad", bundle: nil)
        }
        return type.instantiate(using: sb)
    }
    
}
