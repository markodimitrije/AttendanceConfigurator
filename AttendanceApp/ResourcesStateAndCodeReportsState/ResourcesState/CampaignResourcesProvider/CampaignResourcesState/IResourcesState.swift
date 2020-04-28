//
//  IResourcesState.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IResourcesState {
    func downloadResources()
    var oResourcesDownloaded: Observable<Bool> {get}
    func stopTimer()
}
