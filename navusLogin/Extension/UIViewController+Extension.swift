//
//  UIViewController+Extension.swift
//  navusLogin
//
//  Created by Marko Dimitrijevic on 13/04/2020.
//  Copyright © 2020 Marko Dimitrijevic. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func topViewController() -> UIViewController {
        return UIViewController.topViewControllerWithRootViewController(UIApplication.shared.keyWindow!.rootViewController!)
    }
    
    static func topViewControllerWithRootViewController(_ root: UIViewController) -> UIViewController {
        if root is UITabBarController {
            let tabBarController = root as! UITabBarController
            return UIViewController.topViewControllerWithRootViewController(tabBarController.selectedViewController!)
        } else if root is UINavigationController {
            let navigationController = root as! UINavigationController
            return UIViewController.topViewControllerWithRootViewController(navigationController.viewControllers.last!)
        } else if root.presentedViewController != nil {
            let presentedViewController = root.presentedViewController!
            if presentedViewController is UISearchController {
                return root
            }
            return  UIViewController.topViewControllerWithRootViewController(presentedViewController)
        } else {
            return root
        }
    }
}

