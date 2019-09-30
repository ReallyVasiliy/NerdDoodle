//
//  UIImage+Screenshot.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDraw
import CoreGraphics

extension SwiftyDrawView {
    func strokeBounds() -> CGRect? {
        let lineBounds = self.lines.map { $0.path.boundingBox }.filter { $0.size.width > 5.0 || $0.size.height > 5.0 }
        if lineBounds.count < 1 {
            return nil
        }
        var min = CGPoint(x: lineBounds[0].minX, y: lineBounds[0].minY)
        var max = CGPoint(x: lineBounds[0].maxX, y: lineBounds[0].maxY)
        let scale: CGFloat = UIScreen.main.scale
        
        for bounds in lineBounds {
            
            if bounds.maxX > max.x {
                max.x = bounds.maxX
            }
            if bounds.maxY > max.y {
                max.y = bounds.maxY
            }
            if bounds.minX < min.x {
                min.x = bounds.minX
            }
            if bounds.minY < min.y {
                min.y = bounds.minY
            }
        }
        let brush = self.brush.width * scale
        
        var scaledMin = CGPoint(x: (min.x) * scale, y: (min.y) * scale)
        let scaledSize = CGSize(width: (max.x - min.x) * scale, height: (max.y - min.y) * scale)
        var size: CGFloat
        let delta = scaledSize.height - scaledSize.width
        
        if delta < 0 { // Width > height
            size = scaledSize.width
            scaledMin.y -= (-delta * 0.5)
        } else {
            size = scaledSize.height
            scaledMin.x -= (delta * 0.5)
        }
        
        size += brush * 2.0
        
//        let size: CGFloat = ((scaledSize.width > scaledSize.height) ? scaledSize.width : scaledSize.height) + brush * 2.0
        return CGRect(origin: CGPoint(x: scaledMin.x - brush, y: scaledMin.y - brush), size: CGSize(width: size, height: size))
    }
}

extension UIView {
    func screenshot(bounds: CGRect) -> UIImage? {
        let size = CGSize(width: bounds.size.width * (1.0 / UIScreen.main.scale), height: bounds.size.height * (1.0 / UIScreen.main.scale))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: CGRect(origin: CGPoint.zero, size: size), afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
