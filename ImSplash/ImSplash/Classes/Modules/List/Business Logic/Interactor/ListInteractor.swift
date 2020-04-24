//
//  ListInteractor.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit
class ListInteractor: NSObject {
    var output: ListInteractorOutput?
    let dataManager: DataManager
    let downloadManager: DownloadManager
    
    init(dataManager: DataManager, downloadManager: DownloadManager) {
        self.dataManager = dataManager
        self.downloadManager = downloadManager
        super.init()
        self.downloadManager.delegate = self
    }
}
extension ListInteractor: ListInteractorInput {
    func getActiveDownloads() -> [URL: DownloadRequest] {
        return downloadManager.activeDownloads
    }
    
    func loadData() {
        let downloads = downloadManager.activeDownloads
//        dataManager.getDataCollection { (downloadedList, favList) in
//            var downloadList = [DownloadRequest]()
//            for (_, download) in downloads {
//                if download.isDownloading {
//                    downloadList.append(download)
//                }
//            }
//            self.output?.didReceiveDownloadList(downloadList, downloadedList: downloadedList, favList: favList)
//        }
//        let downloadedList = dataManager.getDownloadedLocalImages()
//        let favList = dataManager.getFavoriteLocalImages()
        let (downloadedList, favList) = dataManager.getDataCollection()
        var downloadList = [DownloadRequest]()
        for (_, download) in downloads {
            if download.isDownloading {
                downloadList.append(download)
            }
        }
        self.output?.didReceiveDownloadList(downloadList, downloadedList: downloadedList, favList: favList)
    }
    
    func changeFavorite(id: String) {
        dataManager.changeLocalImageFavorite(id: id)
    }
    
    func changeFavorite(id: String, urlRegular: String, width: Int, height: Int) {
        dataManager.changeLocalImageFavorite(id: id, urlRegular: urlRegular, width: width, height: height)
    }
}
extension ListInteractor: DownloadManagerDelegate {
    func progressIsChanged(progress: Float, id: String) {
        DispatchQueue.main.async {
            let topViewController = DisplayUtils.getTopViewController()
            print("ListInteractor - Progress changed - top view controller: \(topViewController.debugDescription)")
            if topViewController is ListViewController {
                print("ListInteractor - Progress changed - update UI")
                (topViewController as? ListViewController)?.updateItemWithId(id, progress: progress)
            }
        }
    }
    
    func didUpdateLocal(destinationURL: String, id: String, width: Int, height: Int) {
        DispatchQueue.main.async {
            self.dataManager.saveDownloadedFilePath(destinationURL, id: id, width: width, height: height)
        
            let topViewController = DisplayUtils.getTopViewController()
            print("ListInteractor - Save photo - top view controller: \(topViewController.debugDescription)")
            if topViewController is ListViewController {
                print("ListInteractor - Save photo - update UI")
                (topViewController as? ListViewController)?.loadData()
            }
        }
    }
}
