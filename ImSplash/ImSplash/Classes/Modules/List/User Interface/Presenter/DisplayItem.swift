//
//  DisplayItem.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
struct TransLocalImage {
    var id = ""
    var width: Int = 1
    var height: Int = 1
    var urlRegular: String?
    var localImagePath: String?
    var favorite = false
    var isDownloaded = false
    var isDownloading = false
    var progress : Float = 0
    
    init(local: LocalImage) {
        self.id = local.id
        self.width = local.width
        self.height = local.height
        self.urlRegular = local.urlRegular
        self.localImagePath = local.localImagePath
        self.favorite = local.favorite
        self.isDownloaded = local.isDownloaded
    }
    
    init(id: String, width: Int, height: Int, urlRegular: String?, localImagePath: String?, favorite: Bool, isDownloaded: Bool) {
        self.id = id
        self.width = width
        self.height = height
        self.urlRegular = urlRegular
        self.localImagePath = localImagePath
        self.favorite = favorite
        self.isDownloaded = isDownloaded
    }
    
    init(photo: UnsplashPhoto) {
        self.id = photo.identifier
        self.width = photo.width
        self.height = photo.height
        self.urlRegular = photo.urls[.regular]?.absoluteString
        self.localImagePath = nil
        self.favorite = false
        self.isDownloaded = false
    }
}
struct DisplayItem {
    var localItem: TransLocalImage?
    var download: DownloadRequest?
    var isFavorite = false
}
