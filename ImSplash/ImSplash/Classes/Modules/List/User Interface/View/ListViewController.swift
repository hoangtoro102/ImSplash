//
//  ListViewController.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UnsplashPhotoPicker
import RealmSwift
class ListViewController: UIViewController {
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var downloadCollectionView: UICollectionView!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    var eventHandler: ListModuleInterface?
    
    var downloadCollection = DisplayCollection()
    var favCollection = DisplayCollection()
    
    var favList = [TransLocalImage]()
    var dowList = [TransLocalImage]()

    lazy var dlayout = WaterfallLayout(with: self)
    lazy var flayout = WaterfallLayout(with: self)
    
    var isDisplayingDownload = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = false
        navigationItem.title = "Collection"
//        self.eventHandler?.loadData()
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    func setupLayout() {
        print("Setup layout")
        btnDownload.setTitleColor(.red, for: .normal)
        downloadCollectionView.isHidden = false
        favoriteCollectionView.isHidden = true
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        print("Setup collection view")
        downloadCollectionView.collectionViewLayout = dlayout
        downloadCollectionView.translatesAutoresizingMaskIntoConstraints = false
        downloadCollectionView.dataSource = self
        downloadCollectionView.delegate = self
        downloadCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        downloadCollectionView.contentInsetAdjustmentBehavior = .automatic
        downloadCollectionView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        downloadCollectionView.backgroundColor = .white
        
        favoriteCollectionView.collectionViewLayout = flayout
        favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        favoriteCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        favoriteCollectionView.contentInsetAdjustmentBehavior = .automatic
        favoriteCollectionView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        favoriteCollectionView.backgroundColor = .white
    }
    
    @IBAction func touchBtnDownload(_ sender: Any) {
        isDisplayingDownload = true
        btnDownload.setTitleColor(.red, for: .normal)
        btnFavorite.setTitleColor(.black, for: .normal)
        downloadCollectionView.isHidden = false
        favoriteCollectionView.isHidden = true
    }
    
    @IBAction func touchBtnFavorite(_ sender: Any) {
        isDisplayingDownload = false
        btnDownload.setTitleColor(.black, for: .normal)
        btnFavorite.setTitleColor(.red, for: .normal)
        downloadCollectionView.isHidden = true
        favoriteCollectionView.isHidden = false
    }
}
extension ListViewController: ListViewInterface {
    func updateInterfaceWithCollections(fCollection: DisplayCollection, dCollection: DisplayCollection) {
        downloadCollection = dCollection
        favCollection = fCollection
//        DispatchQueue.main.async {
            self.downloadCollectionView.reloadData()
            self.favoriteCollectionView.reloadData()
//        }
    }
    
    func updateInterfaceWithList(_ downloads: [TransLocalImage], favorites: [TransLocalImage]) {
        
    }
}
extension ListViewController {
    func loadData() {
        print("List view controller - load data")
        let realm = try! Realm()
        let items = realm.objects(LocalImage.self)
        let dlist = items.filter("isDownloaded == true")
        let flist = items.filter("favorite == true")
        
        let downloads = self.eventHandler?.getActiveDownloads() ?? [:]
        var downloadList = [DownloadRequest]()
        for (_, download) in downloads {
            if download.isDownloading {
                downloadList.append(download)
            }
        }
        
        dowList = [TransLocalImage]()
        favList = [TransLocalImage]()
        
        for item in downloadList {
            var t = TransLocalImage(photo: item.photo)
            t.isDownloading = true
            
            let id = item.photo.identifier
            let favContains = favList.filter({ $0.id == id }).count > 0
            t.favorite = favContains
            
            dowList.append(t)
            if favContains {
                var ft = TransLocalImage(photo: item.photo)
                ft.favorite = true
                ft.isDownloading = true
                ft.progress = item.progress
                print("Progress to display: \(ft.progress)")
                favList.append(ft)
            }
        }
        
        for item in dlist {
            let t = TransLocalImage(id: item.id, width: item.width, height: item.height, urlRegular: item.urlRegular, localImagePath: item.localImagePath, favorite: item.favorite, isDownloaded: item.isDownloaded)
            dowList.append(t)
        }
        for item in flist {
            let t = TransLocalImage(id: item.id, width: item.width, height: item.height, urlRegular: item.urlRegular, localImagePath: item.localImagePath, favorite: item.favorite, isDownloaded: item.isDownloaded)
            favList.append(t)
        }

//        let dCollection = DisplayCollection(downloads: downloadList, downloadedList: downloadedList, favList: favList)
//
//        let fCollection = DisplayCollection(favList: favList, downloads: downloadList)
        
//            self.downloadCollection = dCollection
//            self.favCollection = fCollection
        
        self.downloadCollectionView.reloadData()
        self.favoriteCollectionView.reloadData()
    }
    
    func updateItemWithId(_ id: String, progress: Float) {
        for (index, item) in dowList.enumerated() {
            if item.id == id {
                let indexPath = IndexPath(item: index, section: 0)
                if let cell = downloadCollectionView.cellForItem(at: indexPath) as? PhotoCell {
                    var newItem = item
                    newItem.progress = progress
                    cell.configure(with: newItem)
                }
                return
            }
        }
        for (index, item) in favList.enumerated() {
            if item.id == id {
                let indexPath = IndexPath(item: index, section: 0)
                if let cell = favoriteCollectionView.cellForItem(at: indexPath) as? PhotoCell {
                    var newItem = item
                    newItem.progress = progress
                    cell.configure(with: newItem)
                }
                return
            }
        }
    }
}
