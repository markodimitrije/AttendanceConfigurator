//
//  DownloadImageAPI.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol IDownloadImageAPI {
    func fetchImage(url: URL) -> Observable<Data>
}
