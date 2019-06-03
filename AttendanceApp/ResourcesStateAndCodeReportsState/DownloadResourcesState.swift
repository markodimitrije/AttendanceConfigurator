//
//  DownloadResourcesState.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 03/06/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import RxCocoa
import RxSwift

class DownloadResourcesState {
    
    // OUTPUT:
    var downloads = BehaviorRelay<[String]>.init(value: [])
    
    // INPUT:
    let newlyDownloaded = BehaviorRelay<String>.init(value: "")
    
    init() {
        newlyDownloaded
            .subscribe(onNext: { [weak self] newResource in
                guard let sSelf = self else {return}
                if newResource != "" {
                    var resources = sSelf.downloads.value
                    resources.append(newResource)
                    sSelf.downloads.accept(resources)
                }
            }).disposed(by: bag)
    }
    
    func resourceStateUpdated() {
        downloads.accept([])
    }
    
    private let bag = DisposeBag()
}
