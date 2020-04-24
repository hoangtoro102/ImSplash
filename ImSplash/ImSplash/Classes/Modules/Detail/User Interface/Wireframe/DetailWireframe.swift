//
//  DetailWireframe.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
class DetailWireframe: NSObject {
    var rootWireframe: RootWireframe?
    var presenter: DetailPresenter?
    
    func presentDetailInterface(_ photo: UnsplashPhoto) {
        let viewController = rootWireframe?.viewControllerFromStoryboardWithIdentifier(String(describing: DetailViewController.self)) as! DetailViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.photo = photo
        viewController.eventHandler = presenter
        presenter?.viewInterface = viewController
        rootWireframe?.presentViewController(viewController)
    }
}
