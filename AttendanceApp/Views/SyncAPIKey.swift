//
//  SyncAPIKey.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 03/06/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import RxCocoa

class SyncApiKeyView: UnsyncedScansView {
    
    var oSyncTap = BehaviorRelay.init(value: ())//.skip(1) // hard-coded ok ?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update(titleText: Constants.syncApiKey, btnText: Constants.sync)
    }
    
    // MARK:- API calls
    func update(titleText: String, btnText: String) {
        self.unsyncScansConstLbl.text = titleText
        self.countLbl.text = ""
        self.syncBtn.setTitle(btnText, for: .normal)
    }
}
