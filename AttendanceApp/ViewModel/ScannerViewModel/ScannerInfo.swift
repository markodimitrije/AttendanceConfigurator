//
//  ScannerInfo.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 04/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IScannerInfo {
    func getTitle() -> String
    func getDescription() -> String
    func getBlockId() -> Int
}

struct ScannerInfo {
    var title = SessionTextData.noActiveSession
    var description = ""
    var blockId = -1
}

extension ScannerInfo: IScannerInfo {
    func getTitle() -> String { self.title }
    func getDescription() -> String {self.description}
    func getBlockId() -> Int {self.blockId}
}
