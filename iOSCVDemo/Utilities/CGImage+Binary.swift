//
//  CGImage+Binary.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-08-01.
//

import CoreGraphics
import UIKit

extension CGImage {
    
    func toGrayscale() -> CGImage? {
        // Get image dimensions
        let width = self.width
        let height = self.height
        
        // Create a gray color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        // Define bitmap info
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        
        // Create a context for the grayscale image
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            return nil
        }
        
        // Draw the original image into the grayscale context
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Create a new CGImage from the grayscale context
        return context.makeImage()
    }
    
    func adaptiveThreshold(threshold: UInt32, kernelSize: Int) -> CGImage {
        let wrapper = OpenCVWrapper()
        let cgImageRaw = wrapper.adaptiveThreshold(Int32(threshold), withKernel: Int32(kernelSize), cgImage: self)!
        
        let cgImage = cgImageRaw.takeUnretainedValue()
        cgImageRaw.release()
        
        return cgImage
    }
    
    func toBinary(threshold: CGFloat) -> CGImage? {
        // Convert CGImage to grayscale first
        guard let grayImage = self.toGrayscale() else {
            return nil
        }
        
        // Get image width and height
        let width = grayImage.width
        let height = grayImage.height
        let bitsPerComponent = 8
        let bytesPerRow = width
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.none.rawValue
        
        // Create a bitmap context to store the binary image data
        var binaryData = [UInt8](repeating: 0, count: height * bytesPerRow)
        
        guard let context = CGContext(data: &binaryData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        // Draw the grayscale image into the context
        context.draw(grayImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Apply threshold to convert grayscale to binary
        for y in 0..<height {
            for x in 0..<width {
                let offset = y * bytesPerRow + x
                let grayValue = binaryData[offset]
                let binaryValue: UInt8 = grayValue >= UInt8(threshold * 255.0) ? 255 : 0
                binaryData[offset] = binaryValue
            }
        }
        
        // Create a new CGImage from the binary data
        let binaryCGImage = context.makeImage()
        
        return binaryCGImage
    }
}
