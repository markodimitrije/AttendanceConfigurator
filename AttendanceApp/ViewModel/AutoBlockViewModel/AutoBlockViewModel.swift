//
//  AutoBlockViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 24/10/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AutoBlockViewModel {
    
    private let bag = DisposeBag()
    private let blockViewModel: BlockViewModel
    
    init(blockViewModel: BlockViewModel) {
        self.blockViewModel = blockViewModel
        bindInputWithOutput()
    }
    
    // OUTPUT
    var selectedBlock = BehaviorSubject<IBlock?>.init(value: nil)
    
    private func bindInputWithOutput() {
        
        blockViewModel.oAutomaticBlock // output svog slave-a
            .asDriver(onErrorJustReturn: nil)
            .do(onNext: { (block) in
                CampaignSettingsRepository.shared.userSelection.blockId = block?.getId() // hazardous hard-coded?
            })
            .drive(selectedBlock) // prosledi na svoj output
            .disposed(by: bag)
    }
    
    deinit {
        print("AutoSelSessionViewModel.deinit")
    }
    
}
