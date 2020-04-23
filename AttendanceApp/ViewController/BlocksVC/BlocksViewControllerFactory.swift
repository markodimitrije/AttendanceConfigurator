//
//  BlocksViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/03/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

class BlocksViewControllerFactory {
    static func make(roomId: Int, selDate: Date?) -> BlocksViewController {
        
        let blocksVC = StoryboardedViewControllerFactory.make(type: BlocksViewController.self) as! BlocksViewController
        blocksVC.blockViewModel = BlockViewModelFactory.make(roomId: roomId, date: selDate)
        
        return blocksVC
    }
}
