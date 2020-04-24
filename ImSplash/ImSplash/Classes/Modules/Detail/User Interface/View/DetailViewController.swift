//
//  DetailViewController.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit
import UnsplashPhotoPicker
class DetailViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbOName: UILabel!
    @IBOutlet weak var imgHeart: UIImageView!
    
    private var imageDownloader = ImageDownloader()
    private var screenScale: CGFloat { return UIScreen.main.scale }
    
    var photo: UnsplashPhoto?
    var isFavorite = false
    var eventHandler: DetailModuleInterface?

    let photoView: PhotoView = {
        // swiftlint:disable force_cast
        let photoView = (PhotoView.nib.instantiate(withOwner: nil, options: nil).first as! PhotoView)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = photo?.identifier {
            eventHandler?.loadLocalImageById(id)
        }
        updateLayout()
        setupPhotoView()
        bindUserPhoto()
    }
    
    private func updateLayout() {
        imgAvatar.layer.cornerRadius = 0.5 * imgAvatar.bounds.size.width
        imgAvatar.layer.borderWidth = 0.1
        imgAvatar.layer.borderColor = UIColor.white.cgColor
        imgAvatar.clipsToBounds = true
    }
    
    func bindUserPhoto() {
        guard let photo = self.photo else { return }
        lbName.text = photo.user.name
        lbOName.text = "@\(photo.user.username)"
        downloadImage(with: photo)
    }

    private func setupPhotoView() {
//        view.preservesSuperviewLayoutMargins = true
        view.addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            photoView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        if let photo = self.photo {
            photoView.configure(with: photo, showsUsername: false)
        }
    }

    private func downloadImage(with photo: UnsplashPhoto) {
        guard let regularUrl = photo.user.profileImage[.small] else { return }

        let url = sizedImageURL(from: regularUrl)

        imageDownloader.downloadPhoto(with: url, completion: { [weak self] (image, isCached) in
            guard let strongSelf = self, strongSelf.imageDownloader.isCancelled == false else { return }

            if isCached {
                strongSelf.imgAvatar.image = image
            } else {
                strongSelf.imgAvatar.image = image
            }
        })
    }

    private func sizedImageURL(from url: URL) -> URL {
        let width: CGFloat = imgAvatar.frame.width * screenScale
        let height: CGFloat = imgAvatar.frame.height * screenScale

        return url.appending(queryItems: [
            URLQueryItem(name: "max-w", value: "\(width)"),
            URLQueryItem(name: "max-h", value: "\(height)")
        ])
    }
    
    @IBAction func touchBtnClose(_ sender: Any) {
        dismiss(animated: true) {}
    }
    
    @IBAction func touchBtnHeart(_ sender: Any) {
        guard let photo = self.photo else { return }
        eventHandler?.changeFavorite(photo)
        isFavorite = !isFavorite
        imgHeart.image = UIImage(named: isFavorite ? "ic_heart_red" : "ic_heart")
    }
    
    @IBAction func touchBtnDownload(_ sender: Any) {
        guard let photo = self.photo else {
            return
        }
        eventHandler?.downloadPhoto(photo)
    }
}
extension DetailViewController: DetailViewInterface {
    func updateUIWithLocalItem(_ item: LocalImage) {
        isFavorite = item.favorite
        imgHeart.image = UIImage(named: isFavorite ? "ic_heart_red" : "ic_heart")
    }
    
    func displayDownloadedAlert() {
        let alert = UIAlertController(title: "Downloaded", message: "", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
