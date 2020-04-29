//
//  AlertErrorPresenter.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 14/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class AlertErrorPresenter: IAlertErrorPresenter {
    func present(error: Error) {
        DispatchQueue.main.async {
            let topVC = UIViewController.topViewController()
            if topVC is UIAlertController {
                return
            }
            let alertVC = ErrorAlertControllerFactory.make(error: error)
            topVC.present(alertVC, animated: true)
        }
    }
}
