//
//  AlertErrorPresenter.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 14/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class AlertErrorPresenter: IAlertErrorPresenter {
    func showAlert(error: Error) {
        let alertVC = ErrorAlertControllerFactory.make(error: error)
        UIViewController.topViewController().present(alertVC, animated: true)
    }
}
