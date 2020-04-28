//
//  LogoutWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit
import RxSwift

class LogoutWorker {
    private let logoutRemoteApi: ILogoutRemoteApi
    private let userState: IUserStateRepository
    private let genericRepo: IGenericRealmRepository
    
    private let bag = DisposeBag()
    
    init(logoutRemoteApi: ILogoutRemoteApi, userState: IUserStateRepository, genericRepo: IGenericRealmRepository) {
        self.logoutRemoteApi = logoutRemoteApi
        self.userState = userState
        self.genericRepo = genericRepo
    }
}

extension LogoutWorker: ILogoutWorker {

    func logoutConfirmed() {
        logoutRemoteApi.logout()
            .subscribe()
            .disposed(by: bag)
        
        userState.logout()
        _ = genericRepo.deleteAllDataIfAny()//TODO marko: should it delete all ??
    }
    
}

struct LogoutButtonFactory {
    func make(target: Any) -> UIBarButtonItem {
        return UIBarButtonItem(title: "Log out",
                               style: .plain,
                               target: target,
                               action: #selector(LogoutHandler.logoutTap))
    }
}
