//
//  Extensions.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/23/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit
public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            if let visibleViewController = nc.visibleViewController {
                return UIWindow.getVisibleViewControllerFrom(visibleViewController)
            }
            if let lastViewController = nc.viewControllers.last {
                return UIWindow.getVisibleViewControllerFrom(lastViewController)
            }
            return vc
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}
