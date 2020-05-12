//
//  SortDescriptor+Ext.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 12/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift

extension SortDescriptor { // TODO, premesti u Frm i rename into createdAt
    static var dateNewestFirst: SortDescriptor {
        return SortDescriptor.init(keyPath: "date", ascending: false)
    }
    static var dateOldestFirst : SortDescriptor {
        SortDescriptor.init(keyPath: "date", ascending: true)
    }
}
