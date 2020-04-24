//
//  HomeModuleInterface.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/20/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
protocol HomeModuleInterface {
    func dataSourceReset()
    func fetchNextPage()
    
    func showPhotoDetail(_ photo: UnsplashPhoto)
    
    func showDownloadList()
}
