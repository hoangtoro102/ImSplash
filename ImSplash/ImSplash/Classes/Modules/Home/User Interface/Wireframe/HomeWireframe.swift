//
//  HomeWireframe.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/20/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit
import UnsplashPhotoPicker
class HomeWireframe: NSObject {
    var rootWireframe: RootWireframe?
    var detailWireframe: DetailWireframe?
    var listWireframe: ListWireframe?
    var presenter: HomePresenter?
    var homeViewController: HomeViewController?
    
    func presentMainInterfaceFromWindow(_ window: UIWindow) {
        let viewController = rootWireframe?.viewControllerFromStoryboardWithIdentifier(String(describing: HomeViewController.self)) as! HomeViewController
        viewController.eventHandler = presenter
        presenter?.viewInterface = viewController
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentDetailWireframe(_ photo: UnsplashPhoto) {
        detailWireframe?.presentDetailInterface(photo)
    }
    
    func presentListWireframw() {
        listWireframe?.presentListInterface()
    }
}
