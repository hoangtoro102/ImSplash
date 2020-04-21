//
//  RootWireframe.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit
class RootWireframe : NSObject {
    func showRootViewController(_ viewController: UIViewController, inWindow: UIWindow) {
        let navigationController = navigationControllerFromWindow(inWindow)
        navigationController.viewControllers = [viewController]
    }
    
    func navigationControllerFromWindow(_ window: UIWindow) -> UINavigationController {
        let navigationController = window.rootViewController as! UINavigationController
        return navigationController
    }
    
    func pushViewController(_ viewController: UIViewController) {
        let navigationController = navigationControllerFromWindow(UIApplication.shared.windows[0])
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func popViewController() {
        let navigationController = navigationControllerFromWindow(UIApplication.shared.windows[0])
        navigationController.popViewController(animated: false)
    }
    
    func popToViewController(_ viewController: UIViewController) {
        let navigationController = navigationControllerFromWindow(UIApplication.shared.windows[0])
        navigationController.popToViewController(viewController, animated: false)
    }
    
    func presentViewController(_ viewController: UIViewController) {
        let navigationController = navigationControllerFromWindow(UIApplication.shared.windows[0])
        navigationController.viewControllers.last?.present(viewController, animated: false, completion: {})
    }
    
    func viewControllerFromStoryboardWithIdentifier(_ identifier: String, module: String? = nil) -> UIViewController {
        let storyboard = module == nil ? mainStoryboard() : storyboardFromName(name: module!)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
    
    func storyboardFromName(name: String) -> UIStoryboard {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard
    }
}
