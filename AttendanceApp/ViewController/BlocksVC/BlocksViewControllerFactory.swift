//
//  BlocksViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class BlocksViewControllerFactory {
    static func make(roomId: Int, selDate: Date?) -> BlocksVC {
        let sb = MainStoryboardFactory.make()
        let blocksVC = sb.instantiateViewController(withIdentifier: "BlocksVC") as! BlocksVC
        blocksVC.blockViewModel = BlockViewModelFactory.make(roomId: roomId, date: selDate)
//        blocksVC.selectedRoomId = roomId
//        blocksVC.selectedDate = selDate
        
        return blocksVC
    }
}
