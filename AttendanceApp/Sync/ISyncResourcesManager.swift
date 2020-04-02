//
//  ISyncResourcesManager.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 02/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxCocoa

protocol ISyncResourcesManager {
    func downloadResources()
    func newResourcesDownloaded()
    var oResourcesDownloaded: BehaviorRelay<Bool> {get}
}
