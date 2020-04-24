//
//  DisplayUtils.swift
//  ImSplash
//
//  Created by Hoang Nguyen on 4/23/20.
//  Copyright © 2020 Hoang Nguyen. All rights reserved.
//

import Foundation
import UIKit
public class DisplayUtils {
    public static func getTopViewController() -> UIViewController! {
        return UIApplication.shared.windows[0].visibleViewController
//        let appDelegate = UIApplication.shared.delegate
//        if let window = appDelegate!.window { return window?.visibleViewController }
//        return nil
    }
}
