//
//  DownloadStatus.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 26/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

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
