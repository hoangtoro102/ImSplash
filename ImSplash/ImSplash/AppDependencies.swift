//
//  AppDependencies.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/20/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit

class AppDependencies {
    let homeWireframe = HomeWireframe()
    
    init() {
        configureDependencies()
    }
    
    func installRootViewControllerIntoWindow(_ window: UIWindow) {
        homeWireframe.presentMainInterfaceFromWindow(window)
    }
    
    func configureDependencies() {
        let rootWireframe = RootWireframe()
        
        // MARK: Home Module
        let homeInteractor = HomeInteractor()
        let homePresenter = HomePresenter()
                
        homeInteractor.output = homePresenter
        
        homeWireframe.presenter = homePresenter
        homeWireframe.rootWireframe = rootWireframe
        
        homePresenter.interactor = homeInteractor
    }
}
