//
//  DetailPresenter.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
class DetailPresenter: NSObject {
    var viewInterface: DetailViewInterface?
    var interactor: DetailInteractorInput?
}
extension DetailPresenter: DetailModuleInterface {
    func loadLocalImageById(_ id: String) {
        interactor?.loadLocalImageById(id)
    }
    
    func changeFavorite(_ photo: UnsplashPhoto) {
        interactor?.changeFavorite(photo)
    }
    
    func downloadPhoto(_ photo: UnsplashPhoto) {
        interactor?.downloadPhoto(photo)
    }
}
extension DetailPresenter: DetailInteractorOutput {
    func didReceiveLocalItem(_ item: LocalImage) {
        viewInterface?.updateUIWithLocalItem(item)
    }
    
    func itemIsDownloaded() {
        viewInterface?.displayDownloadedAlert()
    }
}
