//
//  DownloadItem.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
struct DownloadItem {
    var id: String
    var url: String
    var imageData: UIImage?
    var progress: Float = 0
    var isExecuting = false
    var isFinished = false
    
    init(id: String, url: String) {
        self.id = id
        self.url = url
    }
}
