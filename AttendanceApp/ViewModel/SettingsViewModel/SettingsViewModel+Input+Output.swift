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
        let sessionSelected: Driver<Int?>
        let sessionSwitch: Driver<Bool>
        let blockSelectedManually: Driver<Bool>
    }
    
    struct Output {
        let roomTxt: Driver<String>
        let sessionTxt: Driver<String>
        let dateTxt: Driver<String>
        let compositeSwitch: Driver<Bool>
        let saveSettingsAllowed: Driver<Bool>
        let finishTrigger: Driver<Void>
    }
}
