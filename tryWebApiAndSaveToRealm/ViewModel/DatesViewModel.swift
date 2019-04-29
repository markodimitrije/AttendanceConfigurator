//
//  DatesViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 29/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import Foundation


struct DatesViewmodel {
    
    private var blockViewmodel: BlockViewModel
    
    var data: [String] {
        let rBlocks = blockViewmodel.sectionBlocks.compactMap {$0.first}
        let startDates: [String] = rBlocks.compactMap {$0.starts_at}
        let datesOnly = startDates.map {Date.parseIntoDateOnly($0)}
        let dates = datesOnly.map {"\($0)"}
        return dates
    }
    
    init(blockViewmodel: BlockViewModel) {
        self.blockViewmodel = blockViewmodel
    }
    
}
