//
//  IUnziper.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 31/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation
import RxSwift

protocol IUnziper {
    func saveDataAsFile(data: Data) -> Observable<Bool>
    func unzipData(success: Bool) -> Observable<Data>
}
