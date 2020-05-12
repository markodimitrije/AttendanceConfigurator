//
//  ICodeReportsRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 06/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift

protocol ICodeReportsRepository: ICodeReportsQueryImmutableRepository, ICodeReportsMutableRepository {}
