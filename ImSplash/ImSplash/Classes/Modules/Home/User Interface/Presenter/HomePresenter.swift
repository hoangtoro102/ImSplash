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
