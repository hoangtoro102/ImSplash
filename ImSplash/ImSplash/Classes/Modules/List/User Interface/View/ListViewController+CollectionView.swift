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
            return dowList.count
        }
        return favList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath)
        
        guard let photoCell = cell as? PhotoCell else { return cell }
        photoCell.favoriteDelegate = self
        photoCell.showHeart = true
        if collectionView == downloadCollectionView {
            let localItem = dowList[indexPath.item]
            photoCell.configure(with: localItem)
        } else {
            let localItem = favList[indexPath.item]
            photoCell.configure(with: localItem)
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
        } else {
            let localItem = favList[indexPath.item]
            height = CGFloat(localItem.height) * width / CGFloat(localItem.width)
            return CGSize(width: width, height: height)
        }
    }
}

// MARK: - WaterfallLayoutDelegate
extension ListViewController: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layout == dlayout {
            let localItem = dowList[indexPath.item]
            return CGSize(width: localItem.width, height: localItem.height)
        } else {
            let localItem = favList[indexPath.item]
            return CGSize(width: localItem.width, height: localItem.height)
        }
    }
}
extension ListViewController: PhotoCellDelegateForFavorite {
    func changeFavorite(on photoCell: PhotoCell) {
        if isDisplayingDownload {
            if let indexPath = downloadCollectionView.indexPath(for: photoCell) {
                let localItem = dowList[indexPath.item]
                eventHandler?.changeFavorite(id: localItem.id)
                updateFavoriteForFav(changedItem: localItem)
            }
        } else {
            if let indexPath = favoriteCollectionView.indexPath(for: photoCell) {
                let localItem = favList[indexPath.item]
                eventHandler?.changeFavorite(id: localItem.id)
                updateFavoriteForDownloads(changedItem: localItem)
                if localItem.favorite {
                    favList.removeAll(where: {$0.id == localItem.id})
                    favoriteCollectionView.deleteItems(at: [indexPath])
                }
            }
        }
    }
    
    func updateFavoriteForDownloads(changedItem: TransLocalImage) {
        for (index, item) in dowList.enumerated() {
            if item.id == changedItem.id {
                let indexPath = IndexPath(item: index, section: 0)
                if let cell = downloadCollectionView.cellForItem(at: indexPath) as? PhotoCell {
                    var newItem = changedItem
                    newItem.favorite = !item.favorite
                    cell.configure(with: newItem)
                }
                return
            }
        }
    }
    
    func updateFavoriteForFav(changedItem: TransLocalImage) {
        for (index, item) in favList.enumerated() {
            if item.id == changedItem.id {
                let indexPath = IndexPath(item: index, section: 0)
                if let cell = favoriteCollectionView.cellForItem(at: indexPath) as? PhotoCell {
                    var newItem = item
                    newItem.favorite = !item.favorite
                    cell.configure(with: newItem)
                }
                return
            }
        }
        loadData()
    }
}
