//
//  DataManager.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import RealmSwift
class DataManager: NSObject {
    private let realm = try! Realm()
    
    func getListLocalImages() -> [LocalImage] {
//        let realm = try! Realm()
        let list = realm.objects(LocalImage.self)
        return list.map {$0}
    }
    
    func changeLocalImageFavorite(id: String) {
//        let realm = try! Realm()
        if let item = realm.object(ofType: LocalImage.self, forPrimaryKey: id) {
            try! realm.write {
                item.favorite = !item.favorite
            }
        } else {
            let item = LocalImage()
            item.id = id
            item.favorite = true
            try! realm.write {
                realm.add(item)
            }
        }
    }
    
    func changeLocalImageFavorite(id: String, urlRegular: String, width: Int, height: Int) {
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//        let realm = try! Realm()
        if let item = realm.object(ofType: LocalImage.self, forPrimaryKey: id) {
            try! realm.write {
                item.urlRegular = urlRegular
                item.favorite = !item.favorite
                item.width = width
                item.height = height
            }
        } else {
            let item = LocalImage()
            item.id = id
            item.favorite = true
            item.urlRegular = urlRegular
            item.width = width
            item.height = height
            try! realm.write {
                realm.add(item)
            }
        }
//            }
//        }
    }
    
    func getLocalImageById(_ id: String) -> LocalImage? {
//        let realm = try! Realm()
        let specificItem = realm.object(ofType: LocalImage.self, forPrimaryKey: id)
        return specificItem
    }
    
    func saveDownloadedFilePath(_ filePath: String, id: String, width: Int, height: Int) {
        print("DataManager - saveDownloadedFilePath")
//        DispatchQueue(label: "background").async {
//        autoreleasepool {
//        let realm = try! Realm()
            if let item = self.realm.object(ofType: LocalImage.self, forPrimaryKey: id) {
            try! self.realm.write {
                item.localImagePath = filePath
                item.isDownloaded = true
                item.width = width
                item.height = height
            }
        } else {
            let item = LocalImage()
            item.id = id
            item.localImagePath = filePath
            item.isDownloaded = true
            item.width = width
            item.height = height
            try! self.realm.write {
                self.realm.add(item)
            }
            }
//        }}
    }
    
//    func getDownloadedLocalImages() -> [LocalImage] {
//        let realm = try! Realm()
//        let list = realm.objects(LocalImage.self).filter("isDownloaded == true")
//        return list.map {$0}
//    }
//
//    func getFavoriteLocalImages() -> [LocalImage] {
//        let realm = try! Realm()
//        let list = realm.objects(LocalImage.self).filter("favorite == true")
//        return list.map {$0}
//    }
    
    func isLocalImageDownloaded(_ id: String) -> Bool {
//        let realm = try! Realm()
        let specificItem = realm.object(ofType: LocalImage.self, forPrimaryKey: id)
        return specificItem?.isDownloaded ?? false
    }
    
    func getDataCollection(completionHandler: @escaping ([TransLocalImage], [TransLocalImage]) -> Void) {
//        var itemsRef: ThreadSafeReference<Results<LocalImage>>?
        print("DataManager - Get data collection")
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                let drealm = try! Realm()
                let all = self.realm.objects(LocalImage.self)
//                itemsRef = ThreadSafeReference(to: all)
                let dlist = all.filter("isDownloaded == true")
                let flist = all.filter("favorite == true")
                
                completionHandler(dlist.map{ TransLocalImage(local: $0)}, flist.map{TransLocalImage(local: $0)})
//            }
//        }
    }
    
    func getDataCollection() -> ([TransLocalImage], [TransLocalImage]) {
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                let drealm = try! Realm()
//                let all = realm.objects(LocalImage.self)
                let dlist = realm.objects(LocalImage.self).filter("isDownloaded == true")
                let flist = realm.objects(LocalImage.self).filter("favorite == true")
                
//                completionHandler(dlist.map{ TransLocalImage(local: $0)}, flist.map{TransLocalImage(local: $0)})
//            }
//        }
        return (dlist.map{ TransLocalImage(local: $0)}, flist.map{TransLocalImage(local: $0)})
    }
}
