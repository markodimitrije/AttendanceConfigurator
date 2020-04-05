//
//  ICodesDumperWorker.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 05/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxCocoa

protocol ICodesDumperWorker {
    var oCodesDumped: BehaviorRelay<Bool> {get}
}
