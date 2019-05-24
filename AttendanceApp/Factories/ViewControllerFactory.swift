//
//  ViewControllerFactory.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 24/05/2019.
//  Copyright © 2019 Navus. All rights reserved.
//

import UIKit

class ViewControllerFactory {
    
    private let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    func makeDatesVC() -> DatesVC {
        
        guard let datesVC = storyboard.instantiateViewController(withIdentifier: "DatesVC") as? DatesVC else {
            fatalError("No DatesVC on Main Storyboard")
        }
        
        let blockViewmodel = BlockViewModel()
        
        datesVC.datesViewmodel = DatesViewmodel.init(blockViewmodel: blockViewmodel)
        return datesVC
        
    }
    
}
