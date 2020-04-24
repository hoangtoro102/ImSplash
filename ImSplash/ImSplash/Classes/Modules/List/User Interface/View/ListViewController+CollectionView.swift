//
//  ListViewController+CollectionView.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UICollectionViewDataSource
extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == downloadCollectionView {
            return dowList.count // downloadCollection.items.count
        }
        return favList.count // favCollection.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath)
        
        guard let photoCell = cell as? PhotoCell else { return cell }
        photoCell.favoriteDelegate = self
        photoCell.showHeart = true
        if collectionView == downloadCollectionView {
            let localItem = dowList[indexPath.item]
            photoCell.configure(with: localItem)
//            let dItem = downloadCollection.items[indexPath.item]
//            if let download = dItem.download {
//                photoCell.configure(with: download)
//            }
        } else {
            let localItem = favList[indexPath.item]
            photoCell.configure(with: localItem)
//            let dItem = favCollection.items[indexPath.item]
//            if let localItem = dItem.localItem {
//                photoCell.configure(with: localItem)
//            }
        }

        return photoCell
    }
}

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        var height : CGFloat = 1
        if collectionView == downloadCollectionView {
            let localItem = dowList[indexPath.item]
            height = CGFloat(localItem.height) * width / CGFloat(localItem.width)
            return CGSize(width: width, height: height)
            
//            let dItem = downloadCollection.items[indexPath.item]
//            if let download = dItem.download {
//                height = CGFloat(download.photo.height) * width / CGFloat(download.photo.width)
//                return CGSize(width: width, height: height)
//            }
        } else {
            let localItem = favList[indexPath.item]
            height = CGFloat(localItem.height) * width / CGFloat(localItem.width)
            return CGSize(width: width, height: height)
//            let dItem = favCollection.items[indexPath.item]
//            if let localItem = dItem.localItem {
//                height = CGFloat(localItem.height) * width / CGFloat(localItem.width)
//                return CGSize(width: width, height: height)
//            }
        }
    }
}

// MARK: - WaterfallLayoutDelegate
extension ListViewController: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layout == dlayout {
            let localItem = dowList[indexPath.item]
            return CGSize(width: localItem.width, height: localItem.height)
//            let dItem = downloadCollection.items[indexPath.item]
//            if let download = dItem.download {
//                return CGSize(width: download.photo.width, height: download.photo.height)
//            }
        } else {
            let localItem = favList[indexPath.item]
            return CGSize(width: localItem.width, height: localItem.height)
//            let dItem = favCollection.items[indexPath.item]
//            if let localItem = dItem.localItem {
//                return CGSize(width: localItem.width, height: localItem.height)
//            }
        }
//        return .zero
    }
}
extension ListViewController: PhotoCellDelegateForFavorite {
    func changeFavorite(on photoCell: PhotoCell) {
        if isDisplayingDownload {
            if let indexPath = downloadCollectionView.indexPath(for: photoCell) {
                let localItem = dowList[indexPath.item]
                eventHandler?.changeFavorite(id: localItem.id)
//                let dItem = downloadCollection.items[indexPath.item]
//                if let download = dItem.download {
//                    let photo = download.photo
//                    eventHandler?.changeFavorite(id: photo.identifier, urlRegular: photo.urls[.regular]?.absoluteString ?? "", width: photo.width, height: photo.height)
//                }
            }
        } else {
            if let indexPath = favoriteCollectionView.indexPath(for: photoCell) {
                let localItem = favList[indexPath.item]
                eventHandler?.changeFavorite(id: localItem.id)
//                let dItem = favCollection.items[indexPath.item]
//                if let localItem = dItem.localItem {
//                    eventHandler?.changeFavorite(id: localItem.id)
//                }
            }
        }
    }
}
