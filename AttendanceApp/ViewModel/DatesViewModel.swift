//
//  DatesViewModel.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 29/04/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DatesViewmodel: NSObject, UITableViewDelegate {
    
    //private var blockViewmodel: BlockViewModel
    private let blockRepo: IBlockImmutableRepository
    
    // OUTPUT
    private (set) var selectedDate = PublishSubject<Date?>.init()

//    var data: [Date] {
//        let rBlocks = blockViewmodel.sectionBlocks.compactMap {$0.first}
//        let startDates = rBlocks.map(BlockFactory.make).map {$0.getStartsAt()}
//        return startDates
//    }
//
//    init(blockViewmodel: BlockViewModel) {
//        self.blockViewmodel = blockViewmodel
//    }
    
    var data: [Date] {
        return blockRepo.getAvailableDates(roomId: nil)
    }
    
    init(blockRepo: IBlockImmutableRepository) {
        self.blockRepo = blockRepo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateSelected = data[indexPath.row]
        selectedDate.onNext(dateSelected)
    }
    
}
