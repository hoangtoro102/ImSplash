//
//  ListPresenter.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
class ListPresenter: NSObject {
    var wireframe: ListWireframe?
    var viewInterface: ListViewInterface?
    var interactor: ListInteractorInput?
}
extension ListPresenter: ListModuleInterface {
    func loadData() {
        interactor?.loadData()
    }
    
    func changeFavorite(id: String) {
        interactor?.changeFavorite(id: id)
    }
    
    func changeFavorite(id: String, urlRegular: String, width: Int, height: Int) {
        interactor?.changeFavorite(id: id, urlRegular: urlRegular, width: width, height: height)
    }
    
    func getActiveDownloads() -> [URL: DownloadRequest] {
        return interactor?.getActiveDownloads() ?? [:]
    }
}
extension ListPresenter: ListInteractorOutput {
    func didReceiveDownloadList(_ downloads: [DownloadRequest], downloadedList: [TransLocalImage], favList: [TransLocalImage]) {
        let downloadCollection = DisplayCollection(downloads: downloads, downloadedList: downloadedList, favList: favList)
        
        let favCollection = DisplayCollection(favList: favList, downloads: downloads)
        
        viewInterface?.updateInterfaceWithCollections(fCollection: favCollection, dCollection: downloadCollection)
    }
}
