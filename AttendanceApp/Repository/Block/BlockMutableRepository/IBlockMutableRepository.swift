//
//  IBlockMutableRepository.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 07/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

protocol IBlockMutableRepository {
    //SAVE
    func save(blocks: [IBlock])
    func replaceExistingWith(blocks: [IBlock])
}
