//
//  CampaignResourcesState.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 28/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

extension CampaignResourcesState: IResourcesState {
    
    var oResourcesDownloaded: Observable<DownloadStatus> {
        return _oResourcesDownloaded
    }
}

enum DownloadStatus {
    case success
    case fail(Error)
}

extension DownloadStatus: Equatable {
    static func == (lhs: DownloadStatus, rhs: DownloadStatus) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (fail(let err1), fail(let err2)):
            return err1.localizedDescription == err2.localizedDescription
        default:
            return false
        }
    }
    
    
}

class CampaignResourcesState {
    private let bag = DisposeBag()
    private weak var timer: Timer?
    private var _oResourcesDownloaded = PublishSubject<DownloadStatus>()
    
    private let campaignResourcesWorker: ICampaignResourcesWorker
    init(campaignResourcesWorker: ICampaignResourcesWorker) {
        self.campaignResourcesWorker = campaignResourcesWorker
        fetchResourcesFromWeb()
        if timer == nil { print("creating timer to fetch resources")
            timer = Timer.scheduledTimer(
                        timeInterval: MyTimeInterval.campaignResourcesCheckEvery,
                        target: self,
                        selector: #selector(CampaignResourcesState.fetchResourcesFromWeb),
                        userInfo: nil,
                        repeats: true)
        }
    }
    
    @objc private func fetchResourcesFromWeb() {
        self.campaignResourcesWorker.work()
        .subscribe(onError: { [weak self] (err) in
            //print("fetchResourcesFromWeb = false")
            self?._oResourcesDownloaded.onNext(.fail(err))
        }, onCompleted: { [weak self] in
            //print("fetchResourcesFromWeb = true")
            self?._oResourcesDownloaded.onNext(.success)
        }).disposed(by: bag)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}
