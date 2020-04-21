//
//  HomeViewInterface.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/20/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
protocol HomeViewInterface {
    func showSpinner()
    func hideSpinner()
    func showNoResults()
    func updateWithResult(_ newPhotos: [UnsplashPhoto])
    func showErrorState(_ state: EmptyViewState)
}
