//
//  DetailViewInterface.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/21/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
protocol DetailViewInterface {
    func updateUIWithLocalItem(_ item: LocalImage)
    func displayDownloadedAlert()
}
