//
//  DetailInteractorIO.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
protocol DetailInteractorInput {
    func loadLocalImageById(_ id: String)
    func changeFavorite(_ photo: UnsplashPhoto)
    func downloadPhoto(_ photo: UnsplashPhoto)
}
protocol DetailInteractorOutput {
    func didReceiveLocalItem(_ item: LocalImage)
    func itemIsDownloaded()
}
