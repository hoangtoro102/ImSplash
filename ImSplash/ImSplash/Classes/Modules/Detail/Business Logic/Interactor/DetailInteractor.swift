//
//  DetailInteractor.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
class DetailInteractor: NSObject {
    var output: DetailInteractorOutput?
    
    let dataManager: DataManager
    let downloadManager: DownloadManager
    
    init(dataManager: DataManager, downloadManager: DownloadManager) {
        self.dataManager = dataManager
        self.downloadManager = downloadManager
    }
}
extension DetailInteractor: DetailInteractorInput {
    func loadLocalImageById(_ id: String) {
        if let item = dataManager.getLocalImageById(id) {
            output?.didReceiveLocalItem(item)
        }
    }
    
    func changeFavorite(_ photo: UnsplashPhoto) {
        dataManager.changeLocalImageFavorite(id: photo.identifier, urlRegular: photo.urls[.regular]?.absoluteString ?? "", width: photo.width, height: photo.height)
    }
    
    func downloadPhoto(_ photo: UnsplashPhoto) {
        if dataManager.isLocalImageDownloaded(photo.identifier) {
            output?.itemIsDownloaded()
            return
        }
        downloadManager.startDownload(photo)
    }
}
