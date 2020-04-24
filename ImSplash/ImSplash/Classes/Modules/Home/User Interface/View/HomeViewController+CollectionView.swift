//
//  HomeViewController+CollectionView.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath)
        let photo = photos[indexPath.item]
        guard let photoCell = cell as? PhotoCell else { return cell }

        photoCell.configure(with: photo)

        return photoCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingView.reuseIdentifier, for: indexPath)

        guard let pagingView = view as? PagingView else { return view }

        pagingView.isLoading = isFetching

        return pagingView
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let prefetchCount = 19
        if indexPath.item == photos.count - prefetchCount {
            fetchNextItems()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard photos.count > 0 else { return }
        let photo = photos[indexPath.item]
        eventHandler?.showPhotoDetail(photo)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard photos.count > 0 else { return .zero }
        let photo = photos[indexPath.item]

        let width = collectionView.frame.width
        let height = CGFloat(photo.height) * width / CGFloat(photo.width)
        return CGSize(width: width, height: height)
    }
}

// MARK: - WaterfallLayoutDelegate
extension HomeViewController: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard photos.count > 0 else { return .zero }
        let photo = photos[indexPath.item]

        return CGSize(width: photo.width, height: photo.height)
    }
}
