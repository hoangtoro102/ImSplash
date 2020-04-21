//
//  HomeInteractorIO.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/20/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
protocol HomeInteractorInput {
    func dataSourceReset()
    func fetchNextPage()
}
protocol HomeInteractorOutput {
    func willStartFetching()
    func finishFetchingWithData(_ photos: [UnsplashPhoto])
    func errorWhileFetching(_ state: EmptyViewState)
}
