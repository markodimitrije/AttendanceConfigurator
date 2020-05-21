//
//  IGenRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Foundation

protocol IGenRepository: IGenRealmMutableRepo, IGenImmutableRepo {}

struct GenericRepository: IGenRepository {}
