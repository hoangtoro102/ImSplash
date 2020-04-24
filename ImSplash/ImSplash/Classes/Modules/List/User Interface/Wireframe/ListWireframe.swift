//
//  ListWireframe.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
class ListWireframe: NSObject {
    var rootWireframe: RootWireframe?
    var presenter: ListPresenter?
    
    func presentListInterface() {
        let viewController = rootWireframe?.viewControllerFromStoryboardWithIdentifier(String(describing: ListViewController.self)) as! ListViewController
        viewController.eventHandler = presenter
        presenter?.viewInterface = viewController
        rootWireframe?.pushViewController(viewController)
    }
}
