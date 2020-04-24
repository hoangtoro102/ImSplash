//
//  DownloadRequest.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
public class DownloadRequest {
    //
    // MARK: - Variables And Properties
    //
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var photo: UnsplashPhoto
    
    //
    // MARK: - Initialization
    //
    init(photo: UnsplashPhoto) {
      self.photo = photo
    }
}
