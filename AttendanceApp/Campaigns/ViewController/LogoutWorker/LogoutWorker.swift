//
//  LogoutWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class LogoutWorker {
    private let logoutRemoteApi: ILogoutRemoteApi
    private let userState: IUserStateRepository
    private let genericRepo: IGenericRealmRepository
    
    init(logoutRemoteApi: ILogoutRemoteApi, userState: IUserStateRepository, genericRepo: IGenericRealmRepository) {
        self.logoutRemoteApi = logoutRemoteApi
        self.userState = userState
        self.genericRepo = genericRepo
    }
}

extension LogoutWorker: ILogoutWorker {

    func logoutConfirmed() {
        logoutRemoteApi.logout()
        userState.logout()
        _ = genericRepo.deleteAllDataIfAny()//TODO marko: should it delete all ??
    }
    
}

class LogoutButtonFactory: NSObject {
    func make(target: Any) -> UIBarButtonItem {
        return UIBarButtonItem(title: "Log out",
                               style: .plain,
                               target: target,
                               action: #selector(CampaignsVC.logoutTap))
    }
    
}
