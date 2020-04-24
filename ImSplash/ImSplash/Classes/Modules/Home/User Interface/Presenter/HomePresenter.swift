//
//  HomePresenter.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/20/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
class HomePresenter: NSObject {
    var wireframe: HomeWireframe?
    var viewInterface: HomeViewInterface?
    var interactor: HomeInteractorInput?
}
extension HomePresenter: HomeModuleInterface {
    func dataSourceReset() {
        interactor?.dataSourceReset()
    }
    
    func fetchNextPage() {
        interactor?.fetchNextPage()
    }
    
    func showPhotoDetail(_ photo: UnsplashPhoto) {
        wireframe?.presentDetailWireframe(photo)
    }
    
    func showDownloadList() {
        wireframe?.presentListWireframw()
    }
}
extension HomePresenter: HomeInteractorOutput {
    func willStartFetching() {
        viewInterface?.showSpinner()
    }
    
    func finishFetchingWithData(_ photos: [UnsplashPhoto]) {
        viewInterface?.hideSpinner()
        viewInterface?.updateWithResult(photos)
    }
    
    func errorWhileFetching(_ state: EmptyViewState) {
        viewInterface?.hideSpinner()
        viewInterface?.showErrorState(state)
    }
}
