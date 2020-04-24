//
//  HomeViewController.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/20/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit
import UnsplashPhotoPicker
class HomeViewController: UIViewController {
    var eventHandler: HomeModuleInterface?
    @IBOutlet weak var collectionView: UICollectionView!

    private lazy var layout = WaterfallLayout(with: self)
    
    var photos = [UnsplashPhoto]()
    
    var isFetching = false

    private let spinner: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.hidesWhenStopped = true
            return spinner
        } else {
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.hidesWhenStopped = true
            return spinner
        }
    }()

    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupSpinner()
        
        print("\(UIApplication.shared.windows[0].rootViewController)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if photos.count == 0 {
            refresh()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { (_) in
            self.layout.invalidateLayout()
        })
    }

    // MARK: - Setup

    private func setupSpinner() {
        view.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.collectionViewLayout = layout
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.register(PagingView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PagingView.reuseIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        collectionView.backgroundColor = .white
    }

    private func showEmptyView(with state: EmptyViewState) {
        emptyView.state = state

        guard emptyView.superview == nil else { return }

        spinner.stopAnimating()

        view.addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func hideEmptyView() {
        emptyView.removeFromSuperview()
    }

    // MARK: - Actions
    @IBAction func touchedBtnDownload(_ sender: Any) {
        eventHandler?.showDownloadList()
    }

    private func scrollToTop() {
        let contentOffset = CGPoint(x: 0, y: -collectionView.safeAreaInsets.top)
        collectionView.setContentOffset(contentOffset, animated: false)
    }

    // MARK: - Data

    @objc func refresh() {
        guard photos.isEmpty else { return }

        if isFetching == false && photos.count == 0 {
            eventHandler?.dataSourceReset()
            reloadData()
            fetchNextItems()
        }
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func fetchNextItems() {
        eventHandler?.fetchNextPage()
    }

    private func fetchNextItemsIfNeeded() {
        if photos.count == 0 {
            fetchNextItems()
        }
    }
}
extension HomeViewController: HomeViewInterface {
    func showSpinner() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    func showNoResults() {
        showEmptyView(with: .noResults)
    }
    
    func updateWithResult(_ newPhotos: [UnsplashPhoto]) {
        isFetching = false
        let currentPhotosCount = self.photos.count
        self.photos.append(contentsOf: newPhotos)
        let newPhotosCount = newPhotos.count
        let startIndex = self.photos.count - newPhotosCount
        let endIndex = startIndex + newPhotosCount
        var newIndexPaths = [IndexPath]()
        for index in startIndex..<endIndex {
            newIndexPaths.append(IndexPath(item: index, section: 0))
        }
        let needInsert = newPhotosCount < currentPhotosCount
        DispatchQueue.main.async { [unowned self] in
            self.spinner.stopAnimating()
            self.hideEmptyView()
            
            if needInsert {
                self.collectionView.insertItems(at: newIndexPaths)
            } else {
                self.reloadData()
            }
        }
    }
    
    func showErrorState(_ state: EmptyViewState) {
        isFetching = false
        showEmptyView(with: state)
    }
}
// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
