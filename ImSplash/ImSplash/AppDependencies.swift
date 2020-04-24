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
        
        homePresenter.wireframe = homeWireframe
        homePresenter.interactor = homeInteractor
        
        // MARK: Detail Module
        let dataManager = DataManager()
        let downloadManager = DownloadManager()
        
        let detailWireframe = DetailWireframe()
        let detailInteractor = DetailInteractor(dataManager: dataManager, downloadManager: downloadManager)
        let detailPresenter = DetailPresenter()
        
        detailInteractor.output = detailPresenter
        
        detailWireframe.presenter = detailPresenter
        detailWireframe.rootWireframe = rootWireframe
        
        detailPresenter.interactor = detailInteractor
        
        homeWireframe.detailWireframe = detailWireframe
        
        // MARK: List Module
        let listWireframe = ListWireframe()
        let listInteractor = ListInteractor(dataManager: dataManager, downloadManager: downloadManager)
        let listPresenter = ListPresenter()
        
        listInteractor.output = listPresenter
        
        listWireframe.presenter = listPresenter
        listWireframe.rootWireframe = rootWireframe
        
        listPresenter.interactor = listInteractor
        listPresenter.wireframe = listWireframe
        
        homeWireframe.listWireframe = listWireframe
    }
}
