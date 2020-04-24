//
//  LocalImage.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import RealmSwift
class LocalImage: Object {
    @objc dynamic var id = ""
    @objc dynamic var width: Int = 1
    @objc dynamic var height: Int = 1
    @objc dynamic var urlRegular: String? = nil
    @objc dynamic var localImagePath: String? = nil
    @objc dynamic var favorite = false
    @objc dynamic var isDownloaded = false

    override static func primaryKey() -> String? {
        return "id"
    }
}
