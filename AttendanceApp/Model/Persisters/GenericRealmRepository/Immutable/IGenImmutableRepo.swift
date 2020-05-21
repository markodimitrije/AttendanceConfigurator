//
//  IGenImmutableRepo.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 21/05/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RealmSwift
import RxSwift

protocol IGenImmutableRepo {
    func getObjects<T: Object>(ofType type: T.Type,
                               filter: NSPredicate,
                               sortDescriptors: [SortDescriptor]) throws -> Array<T>
    
    func getObsObjects<T: Object>(ofType type: T.Type,
                                  filter: NSPredicate,
                                  sortDescriptors: [SortDescriptor]) -> Observable<Array<T>>
}
