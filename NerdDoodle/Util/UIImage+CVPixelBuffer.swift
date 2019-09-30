//
//  UIImage+CVPixelBuffer.swift
//  NerdDoodle
//
//  Created by Vasiliy Kulakov on 8/25/19.
//  Copyright © 2019 Vasiliy Kulakov. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

extension UIImage {
    public static let PBUF_SIZE = 28
    
    public convenience init(view: UIView) {
        // draw view in context
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        // get image, return
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    public func cropToBounds(bounds: CGRect) -> UIImage {
        if let cg = self.cgImage {
            let croppedCG = cg.cropping(to: bounds)!
            let image = UIImage(cgImage: croppedCG)
            return image
        } else if let ci = self.ciImage {
            let croppedCI = ci.cropped(to: bounds)
            let image = UIImage(ciImage: croppedCI)
            return image
        }
        return self
    }
    
    public func resize(newSize: CGSize) -> UIImage {
        // create context - make sure we are on a 1.0 scale
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0);
    
        // draw with new size, get image, and return
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return newImage!
    }
    
    public func grayScalePixelBuffer() -> CVPixelBuffer? {
        // create gray scale pixel buffer
        var optionalPixelBuffer: CVPixelBuffer?
        guard CVPixelBufferCreate(kCFAllocatorDefault, UIImage.PBUF_SIZE, UIImage.PBUF_SIZE, kCVPixelFormatType_OneComponent8, nil, &optionalPixelBuffer) == kCVReturnSuccess else {
            return nil
        }
        
        guard let pixelBuffer = optionalPixelBuffer else {
            return nil
        }
        
        // draw image in pixel buffer
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: baseAddress, width: UIImage.PBUF_SIZE, height: UIImage.PBUF_SIZE, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: colorSpace, bitmapInfo: 0)
        context!.draw(cgImage!, in: CGRect(x: 0, y: 0, width: UIImage.PBUF_SIZE, height: UIImage.PBUF_SIZE))
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        
        return pixelBuffer
    }
    
    public func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        var maybePixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         kCVPixelFormatType_32ARGB,
                                         attrs as CFDictionary,
                                         &maybePixelBuffer)
        
        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        guard let context = CGContext(data: pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            else {
                return nil
        }
        
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    
    func invertedImage() -> UIImage? {
        
        let img = CoreImage.CIImage(image: self)
        
        if let filter = CIFilter(name: "CIColorInvert") {
            
            filter.setDefaults()
            filter.setValue(img, forKey: kCIInputImageKey)
            
            let invertedImage = UIImage(ciImage: filter.outputImage!)
            return invertedImage
        }
        return nil
    }
}
