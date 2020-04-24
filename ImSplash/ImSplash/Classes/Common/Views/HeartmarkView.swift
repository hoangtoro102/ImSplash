//
//  HeartmarkView.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import UIKit
protocol HeartmarkViewDelegate {
    func didTouchHeart()
}
class HeartmarkView: UIView {
    
    private var isFavorite = false
    var delegate: HeartmarkViewDelegate?

    override class var layerClass: AnyClass { return CAShapeLayer.self }
    override var intrinsicContentSize: CGSize { return CGSize(width: 24, height: 24) }

    private lazy var heart: UIImageView = {
        let bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "ic_heart", in: bundle, compatibleWith: nil)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(touchHeart), for: .touchUpInside)
        return btn
    }()

    init() {
        super.init(frame: .zero)
        postInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }

    private func postInit() {
//        guard let shapeLayer = layer as? CAShapeLayer else { return }
//        shapeLayer.fillColor = tintColor.cgColor
//        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
//        shapeLayer.shadowRadius = 1
//        shapeLayer.shadowOpacity = 0.25

        addSubview(heart)
        NSLayoutConstraint.activate([
            heart.centerXAnchor.constraint(equalTo: centerXAnchor),
            heart.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: widthAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let shapeLayer = layer as? CAShapeLayer else { return }
        shapeLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        shapeLayer.shadowPath = shapeLayer.path
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        guard let shapeLayer = layer as? CAShapeLayer else { return }
        shapeLayer.fillColor = tintColor.cgColor
    }
    
    @objc func touchHeart() {
        setFavorite(!isFavorite)
        delegate?.didTouchHeart()
    }

    func setFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
        let image = UIImage(named: isFavorite ? "ic_heart_red" : "ic_heart")
        heart.image = image
    }
}
