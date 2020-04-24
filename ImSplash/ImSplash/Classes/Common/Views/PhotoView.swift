//
//  PhotoView.swift
//  Unsplash
//
//  Created by Olivier Collet on 2017-11-06.
//  Copyright © 2017 Unsplash. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class PhotoView: UIView {

    static var nib: UINib { return UINib(nibName: "PhotoView", bundle: Bundle(for: PhotoView.self)) }

    private var imageDownloader = ImageDownloader()
    private var screenScale: CGFloat { return UIScreen.main.scale }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet var overlayViews: [UIView]!
    @IBOutlet weak var lbPercent: UILabel!
    
    var showsUsername = true {
        didSet {
            userNameLabel.alpha = showsUsername ? 1 : 0
            gradientView.alpha = showsUsername ? 1 : 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        accessibilityIgnoresInvertColors = true
        gradientView.setColors([
            GradientView.Color(color: .clear, location: 0),
            GradientView.Color(color: UIColor(white: 0, alpha: 0.5), location: 1)
        ])
    }

    func prepareForReuse() {
        userNameLabel.text = nil
        imageView.backgroundColor = .clear
        imageView.image = nil
        imageDownloader.cancel()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let fontSize: CGFloat = traitCollection.horizontalSizeClass == .compact ? 10 : 13
        userNameLabel.font = UIFont.systemFont(ofSize: fontSize)
    }

    // MARK: - Setup

    func configure(with photo: UnsplashPhoto, showsUsername: Bool = true) {
        self.showsUsername = showsUsername
        userNameLabel.text = photo.user.name
        imageView.backgroundColor = photo.color
        downloadImage(with: photo)
    }

    func configure(with localItem: TransLocalImage) {
        self.showsUsername = false
        userNameLabel.text = ""
        imageView.backgroundColor = .clear
        if localItem.isDownloading {
            // Display percentage
            let percent = localItem.progress * 100
            lbPercent.isHidden = false
            lbPercent.text = String(format: "%.1f%%", percent)
            return
        }
        lbPercent.isHidden = true
        if let path = localItem.localImagePath {
            let exist = FileManager.default.fileExists(atPath: path)
            if let imageURL = URL(string: path) {
                let ex = FileManager.default.fileExists(atPath: imageURL.path)
                let image = UIImage(contentsOfFile: imageURL.path)
                imageView.image = image
            }
        } else if let urlStr = localItem.urlRegular, let url = URL(string: urlStr) {
            downloadImage(with: url)
        } else {
            imageView.image = nil
        }
    }
    
    func configure(with download: DownloadRequest) {
        self.showsUsername = false
        userNameLabel.text = ""
        imageView.backgroundColor = .clear
        // Display percentage
        let percent = download.progress * 100
        lbPercent.text = String(format: "%.1f%%", percent)
    }

    private func downloadImage(with photo: UnsplashPhoto) {
        guard let regularUrl = photo.urls[.regular] else { return }
        downloadImage(with: regularUrl)
    }

    private func downloadImage(with regularUrl: URL) {
        let url = sizedImageURL(from: regularUrl)

        imageDownloader.downloadPhoto(with: url, completion: { [weak self] (image, isCached) in
            guard let strongSelf = self, strongSelf.imageDownloader.isCancelled == false else { return }

            if isCached {
                strongSelf.imageView.image = image
            } else {
                UIView.transition(with: strongSelf, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.imageView.image = image
                }, completion: nil)
            }
        })
    }

    private func sizedImageURL(from url: URL) -> URL {
        let width: CGFloat = frame.width * screenScale
        let height: CGFloat = frame.height * screenScale

        return url.appending(queryItems: [
            URLQueryItem(name: "max-w", value: "\(width)"),
            URLQueryItem(name: "max-h", value: "\(height)")
        ])
    }

    // MARK: - Utility

    class func view(with photo: UnsplashPhoto) -> PhotoView? {
        guard let photoView = nib.instantiate(withOwner: nil, options: nil).first as? PhotoView else {
            return nil
        }

        photoView.configure(with: photo)

        return photoView
    }

}
