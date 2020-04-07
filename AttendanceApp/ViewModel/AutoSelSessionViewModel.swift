//
//  AutoSelSessionViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 24/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AutoSelSessionViewModel {
    
    let bag = DisposeBag()
    let blockViewModel: BlockViewModel!
    
    init(roomId: Int) {
        blockViewModel = BlockViewModelFactory.make(roomId: roomId)
        bindInputWithOutput()
    }
    
    // INPUT:
    var selectedRoom = BehaviorSubject<RealmRoom?>.init(value: nil) // implement me
    var switchState = BehaviorSubject<Bool>.init(value: true)
    
    private var switchStateDriver: SharedSequence<DriverSharingStrategy, Bool> {
        return switchState.asDriver(onErrorJustReturn: false)
    }
    
    // OUTPUT
    var selectedSession = BehaviorSubject<IBlock?>.init(value: nil)
    
    private func bindInputWithOutput() {
        
        // switch binding:
        
        switchStateDriver // switch driver
            .drive(onNext: { tap in // pretplati se da slusas (observe)
                self.blockViewModel.oAutomaticSession // uzmi slave-ov output
                    .asDriver(onErrorJustReturn: nil)
                    .drive(self.selectedSession) // i njime 'pogoni' svoj output
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)

        blockViewModel.oAutomaticSession // output svog slave-a
            .asDriver(onErrorJustReturn: nil)
            .drive(selectedSession) // prosledi na svoj output
            .disposed(by: bag)
        
        blockViewModel.oAutomaticSession
            .subscribe(onNext: { block in
                print("emituj blok koji terba da update moj UI")
                DataAccess.shared.userSelection.blockId = block?.getId() // hazardous hard-coded?
            })
            .disposed(by: bag)
    }
    
    deinit { print("AutoSelSessionViewModel.deinit") }
    
}
