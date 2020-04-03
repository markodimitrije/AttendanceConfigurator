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
import Realm
import RealmSwift

class AutoSelSessionWithWaitIntervalViewModel {
    
    let bag = DisposeBag()
    let blockViewModel: BlockViewModel!
    
    init(roomId: Int) {
        blockViewModel = BlockViewModel.init(roomId: roomId)
        bindInputWithOutput()
    }
    
    // INPUT:
    var selectedRoom = BehaviorSubject<RealmRoom?>.init(value: nil) // implement me
    var switchState = BehaviorSubject<Bool>.init(value: true)
    
    private var inSwitchStateDriver: SharedSequence<DriverSharingStrategy, Bool> {
        return switchState.asDriver(onErrorJustReturn: false)
    }
    
    // OUTPUT
    var selectedSession = BehaviorSubject<Block?>.init(value: nil)
    
    private func bindInputWithOutput() {
        
        // switch binding:
        
        inSwitchStateDriver // switch driver
            .drive(onNext: { tap in // pretplati se da slusas (observe)
                self.blockViewModel.oAutomaticSessionDriver // uzmi slave-ov output
                    .drive(self.selectedSession) // i njime 'pogoni' svoj output
                    .disposed(by: self.bag)
            })
            .disposed(by: bag)

        blockViewModel.oAutomaticSessionDriver // output svog slave-a
            .drive(selectedSession) // prosledi na svoj output
            .disposed(by: bag)
        
        blockViewModel.oAutomaticSession
            .subscribe(onNext: { block in
                print("emituj blok koji terba da update moj UI")
                DataAccess.shared.userSelection.blockId = block?.id // hazardous
            })
            .disposed(by: bag)
        
    }
    
    deinit { print("AutoSelSessionViewModel.deinit") }
    
}
