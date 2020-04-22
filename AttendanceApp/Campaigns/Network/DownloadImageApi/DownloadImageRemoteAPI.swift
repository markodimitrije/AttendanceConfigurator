//
//  DownloadImageRemoteAPI.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

class DownloadImageAPI: IDownloadImageAPI {
    
    private let apiController: ApiController
    init(apiController: ApiController) {
        self.apiController = apiController
    }
    
    func fetchImage(url: URL) -> Observable<Data> {
        apiController.buildRequest(base: url)
    }
    
}


enum DownloadImageError {
    case notUrl
}

extension DownloadImageError: MyError {
    func getHash() -> String {self.localizedDescription}
}
