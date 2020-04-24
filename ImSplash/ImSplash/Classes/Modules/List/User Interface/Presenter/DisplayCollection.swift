//
//  DisplayCollection.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
class DisplayCollection {
    var items = [DisplayItem]()
    
    init() {
        
    }
    
    init(favList: [TransLocalImage], downloads: [DownloadRequest]) {
        items = []
        for item in favList {
            var ditem = DisplayItem()
            if let download = downloads.filter({ $0.photo.identifier == item.id }).first {
                ditem.download = download
            } else {
                ditem.localItem = item
            }
            ditem.isFavorite = true
            items.append(ditem)
        }
    }
    
    init(downloads: [DownloadRequest], downloadedList: [TransLocalImage], favList: [TransLocalImage]) {
        items = []
        for item in downloads {
            var ditem = DisplayItem()
            ditem.download = item
            let id = item.photo.identifier
            let favContains = favList.filter({ $0.id == id }).count > 0
            ditem.isFavorite = favContains
            items.append(ditem)
        }
        for item in downloadedList {
            var ditem = DisplayItem()
            ditem.localItem = item
            ditem.isFavorite = item.favorite
            items.append(ditem)
        }
    }
}
