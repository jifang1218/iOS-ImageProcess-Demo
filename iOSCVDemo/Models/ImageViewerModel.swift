//
//  ImageViewerModel.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-30.
//

import UIKit
import CoreImage

class ImageViewerModel {
    private let fileItem : FileItem
    private var _image: UIImage?
    private var _grayscale: CGImage?
    
    var image: UIImage {
        get {
            if _image == nil {
                _image = UIImage(contentsOfFile: fileItem.fileUrl.path)
            }
            return _image!
        }
        set {
            if _image != newValue {
                _image = newValue
                _grayscale = nil
            }
        }
    }
    
    init(_ aFileItem : FileItem) {
        fileItem = aFileItem
    }

    func adjustHSV(hueAdjust: Float, saturationAdjust: Float, brightnessAdjust: Float) -> UIImage? {
        return _image?.adjustHSV(hueAdjust: hueAdjust, saturationAdjust: saturationAdjust, brightnessAdjust: brightnessAdjust)
    }
    
    func resetImage() -> UIImage {
        _image = UIImage(contentsOfFile: fileItem.fileUrl.path)
        return _image!
    }
    
    func toBinary(threshold: CGFloat) -> UIImage? {
        if _grayscale == nil {
            _grayscale = _image?.cgImage?.toGrayscale()
        }
        return UIImage(cgImage: _grayscale!.toBinary(threshold: threshold / 256.0)!)
    }
    
    func toBinary(threshold: Int, kernel: Int) -> UIImage? {
        if _grayscale == nil {
            _grayscale = _image?.cgImage?.toGrayscale()
        }
        return UIImage(cgImage: _grayscale!.adaptiveThreshold(threshold: UInt32(threshold), kernelSize: kernel))
    }
}
