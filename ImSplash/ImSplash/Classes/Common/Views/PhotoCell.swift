//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-07-26.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker
protocol PhotoCellDelegateForFavorite {
    func changeFavorite(on photoCell: PhotoCell)
}
class PhotoCell: UICollectionViewCell {

    // MARK: - Properties
    var favoriteDelegate: PhotoCellDelegateForFavorite?

    static let reuseIdentifier = "PhotoCell"

    let photoView: PhotoView = {
        // swiftlint:disable force_cast
        let photoView = (PhotoView.nib.instantiate(withOwner: nil, options: nil).first as! PhotoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }()

    private lazy var checkmarkView: CheckmarkView = {
        return CheckmarkView()
    }()

    private lazy var heartmarkView: HeartmarkView = {
        let heart = HeartmarkView()
        heart.delegate = self
        return heart
    }()

    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    var showHeart = false {
        didSet {
            heartmarkView.alpha = showHeart ? 1 : 0
        }
    }
    
    var id: String = ""

    // MARK: - Lifetime

    override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }

    private func postInit() {
        setupPhotoView()
//        setupCheckmarkView()
        setupHeartmarkView()
        heartmarkView.alpha = showHeart ? 1 : 0
        updateSelectedState()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.prepareForReuse()
    }

    private func updateSelectedState() {
        photoView.alpha = 1 // isSelected ? 0.7 : 1
        checkmarkView.alpha = 0 // isSelected ? 1 : 0
    }

    // Override to bypass some expensive layout calculations.
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return .zero
    }

    // MARK: - Setup

    func configure(with photo: UnsplashPhoto) {
        photoView.configure(with: photo)
    }

    func configure(with localItem: TransLocalImage) {
        self.id = localItem.id
        photoView.configure(with: localItem)
        heartmarkView.setFavorite(localItem.favorite)
    }
    
    func configure(with download: DownloadRequest) {
        photoView.configure(with: download)
    }

    private func setupPhotoView() {
        contentView.preservesSuperviewLayoutMargins = true
        contentView.addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setupCheckmarkView() {
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkmarkView)
        NSLayoutConstraint.activate([
            contentView.rightAnchor.constraint(equalToSystemSpacingAfter: checkmarkView.rightAnchor, multiplier: CGFloat(1)),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: checkmarkView.bottomAnchor, multiplier: CGFloat(1))
            ])
    }

    private func setupHeartmarkView() {
        heartmarkView.translatesAutoresizingMaskIntoConstraints = false
        heartmarkView.tintColor = .clear
        heartmarkView.delegate = self
        contentView.addSubview(heartmarkView)
        NSLayoutConstraint.activate([
            contentView.rightAnchor.constraint(equalToSystemSpacingAfter: heartmarkView.rightAnchor, multiplier: CGFloat(1)),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: heartmarkView.bottomAnchor, multiplier: CGFloat(1))
            ])
    }
}
extension PhotoCell: HeartmarkViewDelegate {
    func didTouchHeart() {
        favoriteDelegate?.changeFavorite(on: self)
    }
}
