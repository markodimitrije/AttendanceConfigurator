//
//  Alert+Rx.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 17/04/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import RxSwift
import UIKit

extension UIViewController {

    //AlertInfo
    func alert(alertInfo: AlertInfo, preferredStyle: UIAlertController.Style = .actionSheet, sourceView: UIView? = nil) -> Observable<Int> {
        return Observable.create { [weak self] observer in
            // check if already on screen
            guard self?.presentedViewController == nil else {
                return Disposables.create()
            }
            
            let alertVC = UIAlertController(title: alertInfo.title, message: alertInfo.text, preferredStyle: preferredStyle)
            
            if let popoverController = alertVC.popoverPresentationController {
                if let sourceView = sourceView {
                    popoverController.sourceRect = sourceView.bounds
                    popoverController.sourceView = sourceView
                } else {
                    popoverController.barButtonItem = UIApplication.topViewController()!.navigationItem.rightBarButtonItems?.first
                }
                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            }
            
            _ = alertInfo.btnText.enumerated().map { (index, presentation) -> Void in
                alertVC.addAction(
                    UIAlertAction(title: presentation.title, style: presentation.style, handler: {_ in
                        observer.onNext(index)
                    })
                )
            }
            self?.present(alertVC, animated: true, completion: nil)
            
            return Disposables.create()
        }
    }
    
}
