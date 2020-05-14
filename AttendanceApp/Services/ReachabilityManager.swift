//
//  ReachabilityManager.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 23/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import Reachability

private let reachabilityManager = ReachabilityManager()
// An observable that completes when the app gets online (possibly completes immediately).
func connectedToInternet() -> Observable<Bool> {
    guard let online = reachabilityManager?.reach else {
        return Observable.just(false)
    }
    return online
}

private class ReachabilityManager {
    private let reachability: Reachability?
    let _reach = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return _reach.asObservable().share(replay: 1)
    }
    init?() {
        do {
            reachability = try Reachability()
            try reachability?.startNotifier()
        } catch {
            return nil
        }

        self._reach.onNext(self.reachability!.connection != .unavailable)
        self.reachability!.whenReachable = { _ in
            DispatchQueue.main.async { self._reach.onNext(true) }
        }
        self.reachability!.whenUnreachable = { _ in
            DispatchQueue.main.async { self._reach.onNext(false) }
        }
    }
    deinit {
        reachability!.stopNotifier()
    }
}



/*
final class ReachabilityManager {
    private let reachability: Reachability?
    private let reachReplaySubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return reachReplaySubject.asObservable()
    }

    init?() {
        do {
            reachability = try Reachability()
            try reachability?.startNotifier()
        } catch {
            return nil
        }
        
        reachReplaySubject.onNext(reachability!.connection != .unavailable)
        reachability!.whenReachable = { [weak self] _ in
            DispatchQueue.main.async { self?.reachReplaySubject.onNext(true) }
        }
        reachability!.whenUnreachable = { [weak self] _ in
            DispatchQueue.main.async { self?.reachReplaySubject.onNext(false) }
        }
    }
    
    func isConnectionActive() -> Observable<Bool> {
        return reachReplaySubject.asObservable()
    }
    
    deinit {
        reachability?.stopNotifier()
    }
}
*/
