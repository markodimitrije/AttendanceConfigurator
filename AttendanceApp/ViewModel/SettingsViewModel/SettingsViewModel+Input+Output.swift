//
//  SettingsViewModel+Input+Output.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 01/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

// SettingsViewModel ima direktno povezan wi-fi observer (nije dosledno kodu u ovoj klasi....)

import Foundation
import RxCocoa

extension SettingsViewModel {
    struct Input {
        let cancelTrigger: Driver<Void>
        let saveSettingsTrigger: Driver<Void>
        let dateSelected: Driver<Date?>
        let roomSelected: Driver<Int?>
        let sessionSelected: Driver<Block?>
        let sessionSwitch: Driver<Bool>
        let blockSelectedManually: Driver<Bool>//self.tableView.rx.itemSelected.asDriver()
        let waitInterval: Driver<TimeInterval>
    }
    
    struct Output {
        let roomTxt: Driver<String>
        let dateTxt: Driver<String>
        let sessionTxt: Driver<String>
        let saveSettingsAllowed: Driver<Bool>
        let selectedBlock: Driver<Block?>
        let compositeSwitch: Driver<Bool>
        let sessionInfo: Driver<(Int, Int)?>
    }
}
