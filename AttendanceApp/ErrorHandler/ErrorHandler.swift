
//
//  ErrorHandler.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

extension ErrorHandler: IErrorHandler {
    func handle(error: Error) {
        errorPresenter.present(error: error)
    }
}

class ErrorHandler {
    private let errorPresenter: IAlertErrorPresenter
    init(errorPresenter: IAlertErrorPresenter = AlertErrorPresenter()) {
        self.errorPresenter = errorPresenter
    }
}
