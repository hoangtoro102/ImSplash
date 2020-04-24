//
//  ListModuleInterface.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
protocol ListModuleInterface {
    func loadData()
    
    func changeFavorite(id: String, urlRegular: String, width: Int, height: Int)
    func changeFavorite(id: String)
    
    func getActiveDownloads() -> [URL: DownloadRequest]
}
