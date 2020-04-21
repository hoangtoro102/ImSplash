//
//  HomeInteractor.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/20/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
class HomeInteractor: NSObject {
    var output: HomeInteractorOutput?

    private let editorialDataSource = PhotosDataSourceFactory.collection(identifier: "317099").dataSource

    var dataSource: PagedDataSource {
        didSet {
            oldValue.cancelFetch()
            dataSource.delegate = self
        }
    }

    // MARK: - Lifetime

    override init() {
        self.dataSource = editorialDataSource
        super.init()
        dataSource.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension HomeInteractor: HomeInteractorInput {
    func dataSourceReset() {
        dataSource.reset()
    }
    
    func fetchNextPage() {
        dataSource.fetchNextPage()
    }
}
// MARK: - PagedDataSourceDelegate
extension HomeInteractor: PagedDataSourceDelegate {
    func dataSourceWillStartFetching(_ dataSource: PagedDataSource) {
        if dataSource.items.count == 0 {
            output?.willStartFetching()
        }
    }

    func dataSource(_ dataSource: PagedDataSource, didFetch items: [UnsplashPhoto]) {
        output?.finishFetchingWithData(items)
    }

    func dataSource(_ dataSource: PagedDataSource, fetchDidFailWithError error: Error) {
        let state: EmptyViewState = (error as NSError).isNoInternetConnectionError() ? .noInternetConnection : .serverError

        output?.errorWhileFetching(state)
    }
}
