//
//  ListInteractorIO.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
protocol ListInteractorInput {
    func loadData()
    
    func changeFavorite(id: String, urlRegular: String, width: Int, height: Int)
    func changeFavorite(id: String)
    
    func getActiveDownloads() -> [URL: DownloadRequest]
}
protocol ListInteractorOutput {
    func didReceiveDownloadList(_ downloads: [DownloadRequest], downloadedList: [TransLocalImage], favList: [TransLocalImage])
    
//    func processChanged()
//    func photoIsSaved()
}
