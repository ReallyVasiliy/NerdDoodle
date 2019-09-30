//
//  UIColor+Int.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/28/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: Int, alpha: CGFloat) {
        self.init(red: CGFloat((rgb >> 16) & 0xff) / 255.0,
                  green: CGFloat((rgb >> 08) & 0xff) / 255.0,
                  blue: CGFloat((rgb >> 00) & 0xff) / 255.0,
                  alpha: alpha)
    }
    
    convenience init(rgb: Int) {
        self.init(rgb: rgb, alpha: 1.0)
    }
}
