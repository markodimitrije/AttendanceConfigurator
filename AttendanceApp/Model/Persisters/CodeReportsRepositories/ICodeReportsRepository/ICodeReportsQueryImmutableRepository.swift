//
//  ICodeReportsQueryImmutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

protocol ICodeReportsQueryImmutableRepository: ICodeReportsImmutableRepository {
    func getTotalScansCount(blockId: Int?) -> Int
    func getApprovedScansCount() -> Int
    func getRejectedScansCount() -> Int
    func getSyncedScansCount() -> Int
}
