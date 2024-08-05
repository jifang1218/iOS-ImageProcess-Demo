//
//  UIImage+HSV.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

import UIKit
import CoreImage

extension UIImage {
    
    // hueAdjust: [-Pi, Pi]
    // saturationAdjust: [0, 2]
    // brightnessAdjust: [-1, 1]
    func averageHSV() -> (hue: CGFloat, saturation: CGFloat, value: CGFloat)? {
        guard let ciImage = CIImage(image: self) else {
            NSLog("cannot create CIImage object.")
                return nil
            }
            
        // Create a CIContext
        let context = CIContext()
        
        // Convert the CIImage to a CGImage
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            NSLog("cannot create CGImage object.")
            return nil
        }
        
        // Create a bitmap context to extract pixel data
        let width = Int(ciImage.extent.width)
        let height = Int(ciImage.extent.height)
        let bitsPerComponent = 8
        let bytesPerRow = width * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        // Create a buffer to store the pixel data
        var pixelData = [UInt8](repeating: 0, count: height * bytesPerRow)
        
        guard let bitmapContext = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            NSLog("cannot create bitmap context.")
            return nil
        }
        
        bitmapContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Variables to accumulate sum of HSV values
        var totalHue: CGFloat = 0
        var totalSaturation: CGFloat = 0
        var totalValue: CGFloat = 0
        var count: CGFloat = 0
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * width + x) * 4
                let r = CGFloat(pixelData[offset]) / 255.0
                let g = CGFloat(pixelData[offset + 1]) / 255.0
                let b = CGFloat(pixelData[offset + 2]) / 255.0
                
                var h: CGFloat = 0
                var s: CGFloat = 0
                var v: CGFloat = 0
                
                rgbToHSV(r: r, g: g, b: b, h: &h, s: &s, v: &v)
                
                totalHue += h
                totalSaturation += s
                totalValue += v
                count += 1
            }
        }
        
        // Compute average values
        let averageHue = totalHue / count
        let averageSaturation = totalSaturation / count
        let averageValue = totalValue / count
        
        // Map average values to desired ranges
        // hue => [-pi, pi]
        let mappedHue = averageHue * 2.0 * CGFloat.pi - CGFloat.pi
        // saturation => [0, 2]
        let mappedSaturation = min(max(averageSaturation, 0), 2)
        // brightness => [-1, 1]
        let mappedValue = min(max(averageValue, -1), 1)
        
        return (hue: mappedHue, saturation: mappedSaturation, value: mappedValue)
    }
    
    private func rgbToHSV(r: CGFloat, g: CGFloat, b: CGFloat, h: inout CGFloat, s: inout CGFloat, v: inout CGFloat) {
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        let delta = max - min
        
        v = max
        
        if delta == 0 {
            h = 0
            s = 0
            return
        }
        
        s = delta / max
        
        if r == max {
            h = (g - b) / delta
        } else if g == max {
            h = 2 + (b - r) / delta
        } else {
            h = 4 + (r - g) / delta
        }
        
        h *= 60
        
        if h < 0 {
            h += 360
        }
        
        h = h / 360
    }
    
    // hueAdjust: [-Pi, Pi]
    // saturationAdjust: [0, 2]
    // brightnessAdjust: [-1, 1]
    func adjustHSV(hueAdjust: Float, saturationAdjust: Float, brightnessAdjust: Float) -> UIImage? {
        guard let ciImage = CIImage(image: self) else {
            NSLog("cannot create CIImage object.")
            return nil
        }

        let context = CIContext()
        
        let hueAdjustFilter = CIFilter(name: "CIHueAdjust")
        hueAdjustFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        hueAdjustFilter?.setValue(hueAdjust, forKey: kCIInputAngleKey)
        
        let colorControlsFilter = CIFilter(name: "CIColorControls")
        colorControlsFilter?.setValue(hueAdjustFilter?.outputImage, forKey: kCIInputImageKey)
        colorControlsFilter?.setValue(saturationAdjust, forKey: kCIInputSaturationKey)
        colorControlsFilter?.setValue(brightnessAdjust, forKey: kCIInputBrightnessKey)
        
        guard let outputImage = colorControlsFilter?.outputImage else {
            NSLog("outputImage is nil.")
            return nil
        }
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        NSLog("cannot create cgImage/UIImage.")
        return nil
    }
}
