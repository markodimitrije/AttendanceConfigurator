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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = data[indexPath.row]
        //let date = Date.parse(selected) hard-coded CHANGE...
        let date = NOW // hard-coded
        selectedDate.accept(date)
    }
    
}
