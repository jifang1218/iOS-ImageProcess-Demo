//
//  UIImage+Binary.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-08-02.
//

import CoreGraphics
import UIKit

extension UIImage {
    private func grayScale() -> UIImage? {
        if let img = self.cgImage {
            if let grayScaleImg = img.toGrayscale() {
                return UIImage(cgImage: grayScaleImg)
            }
        }
        return nil
    }
}
