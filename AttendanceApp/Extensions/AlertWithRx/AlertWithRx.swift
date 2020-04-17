//
//  AlertWithRx.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 01/11/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import RxSwift
import RxSwift.Swift
import SwiftOnoneSupport
import RxCocoa
import UIKit

extension UIViewController {
    func alert(title: String, text: String?, btnText: String?) -> Observable<Void> {
        return Observable.create { [weak self] observer in
            // check if already on screen
            guard self?.presentedViewController == nil else {
                return Disposables.create()
            }
            // all good
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(
                UIAlertAction(title: btnText, style: .default, handler: {_ in
                    observer.onCompleted()
                })
            )
            self?.present(alertVC, animated: true, completion: nil)
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

