//
//  DatesViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 29/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import RxCocoa

class DatesViewmodel: NSObject, UITableViewDelegate {
    
    private var blockViewmodel: BlockViewModel
    
    // OUTPUT
    
    private (set) var selectedDate = BehaviorRelay<Date?>.init(value: nil)
    
    var data: [Date] {
        let rBlocks = blockViewmodel.sectionBlocks.compactMap {$0.first}
        let startDates = rBlocks.map(BlockFactory.make).map {$0.getStartsAt()}
        return startDates
    }
    
    init(blockViewmodel: BlockViewModel) {
        self.blockViewmodel = blockViewmodel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateSelected = data[indexPath.row]
        selectedDate.accept(dateSelected)
    }
    
}
