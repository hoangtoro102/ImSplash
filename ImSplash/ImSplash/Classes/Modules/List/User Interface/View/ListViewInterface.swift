//
//  ListViewInterface.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/22/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
protocol ListViewInterface {
    func updateInterfaceWithCollections(fCollection: DisplayCollection, dCollection: DisplayCollection)
    
    func updateInterfaceWithList(_ downloads: [TransLocalImage], favorites: [TransLocalImage])
}
