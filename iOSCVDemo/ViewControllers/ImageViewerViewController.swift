//
//  ImageViewerViewController.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

import UIKit

class ImageViewerViewController : UIViewController,
                                    HSVPanelDelegate,
                                    BinaryImagePanelDelegate,
                                    ImageEditPanelDelegate {
    
    let imageViewer:UIImageView
    let model : ImageViewerModel
    var hsvPanel : HSVPanel?
    var binaryImagePanel : BinaryImagePanel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ aFileItem:FileItem) {
        imageViewer = UIImageView()
        model = ImageViewerModel(aFileItem)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        let image = model.image
        imageViewer.image = image
        
        var frame = self.view.bounds
        frame.origin.y += UIDevice.statusBarHeight() + UIDevice.navigationBarHeight()
        frame.size.height = frame.size.width * image.size.height / image.size.width
        imageViewer.frame = frame
        
        imageViewer.contentMode = .scaleAspectFit
        self.view.addSubview(imageViewer)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                                 style: .plain,
                                                                target: self,
                                                                action: #selector(imageEditButtonPressed(_:)))
    }
    
    @objc func imageEditButtonPressed(_ sender:UIBarButtonItem) {
        let alertController = UIAlertController(title: "Image Processing Options",
                                                message: "Choose an option to process the image",
                                                preferredStyle: .actionSheet)
        
        let adjustHSVAction = UIAlertAction(title: "Saturation + Lightness",
                                            style: .default,
                                            handler: showHSVPanel(_:))
        alertController.addAction(adjustHSVAction)
        
        let convertToBinaryAction = UIAlertAction(title: "Convert to Binary Image",
                                                   style: .default,
                                                   handler: showConvert2BinPanel(_:))
        alertController.addAction(convertToBinaryAction)
        
        let detectFacesAction = UIAlertAction(title: "Face Detection",
                                               style: .default,
                                               handler: showFaceDetectionPanel(_:))
        alertController.addAction(detectFacesAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                          style: .cancel,
                                          handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func imageDoneButtonPressed(_ sender:UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showHSVPanel(_ action:UIAlertAction) -> Void {
        hsvPanel = HSVPanel(frame:self.view.bounds)
        var frame = hsvPanel!.frame;
        frame.size.height = hsvPanel!.frame.height / 4
        frame.origin.y = frame.size.height * 3
        hsvPanel!.frame = frame
        hsvPanel!.delegate = self
        hsvPanel!.imgEditDelegate = self
        self.view.addSubview(hsvPanel!)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .done,
                                                                target: self,
                                                                action: #selector(imageDoneButtonPressed(_:)))
    }
    
    func showConvert2BinPanel(_ action:UIAlertAction) -> Void {
        binaryImagePanel = BinaryImagePanel(frame:self.view.bounds)
        var frame = binaryImagePanel!.frame;
        frame.size.height = binaryImagePanel!.frame.height / 5
        frame.origin.y = frame.size.height * 4
        binaryImagePanel!.frame = frame
        binaryImagePanel!.delegate = self
        binaryImagePanel!.imgEditDelegate = self
        self.view.addSubview(binaryImagePanel!)
        
        // do the convertion, use traditional method (non-adaptive threshold, default threshold 0.5 (128))
        if binaryImagePanel!.useAdaptiveThreshold {
            let threshold = binaryImagePanel!.threshold
            let kernelSize = binaryImagePanel!.kernelSize
            self.imageViewer.image = model.toBinary(threshold: Int(threshold), kernel: kernelSize)
        } else {
            calcBinaryUIImageWithFixedThreshold()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .done,
                                                                target: self,
                                                                action: #selector(imageDoneButtonPressed(_:)))
    }
    
    func showFaceDetectionPanel(_ action:UIAlertAction) -> Void {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                 style: .done,
                                                                target: self,
                                                                action: #selector(imageDoneButtonPressed(_:)))
    }
    
    func hsvValueChanged(hue:Float, saturation:Float, lightness:Float) {
        // from [-180, 180] to [-pi, pi]
        let hue = hue.degreesToRadians
        
        // 0 -- 200 => 0 -- 2
        let sat = Utils.mapValue(from: (-100, 100), to: (0, 2), value: saturation)
        
        // -100 -- 100 => -1 -- 1
        let light = Utils.mapValue(from: (-100, 100), to: (-1, 1), value: lightness)
        
        imageViewer.image = model.adjustHSV(hueAdjust: hue, saturationAdjust: sat, brightnessAdjust: light)
        
    }
    
    private func calcBinaryUIImageWithFixedThreshold()->Void {
        self.imageViewer.image = model.toBinary(threshold: binaryImagePanel!.threshold)
    }
    
    private func calcBinaryUIImageWithAdaptiveThreshold() -> Void {
        let threshold = binaryImagePanel!.threshold
        let kernelSize = binaryImagePanel!.kernelSize
        self.imageViewer.image = model.toBinary(threshold: Int(threshold), kernel: kernelSize)
    }
    
    @objc func reset(_ panel: ImageEditPanel) {
        self.imageViewer.image = model.resetImage()
    }
    
    func useAdaptiveThresholdSwitchChanged(useApativeThreshold: Bool) {
        if binaryImagePanel!.useAdaptiveThreshold {
            calcBinaryUIImageWithAdaptiveThreshold()
        } else {
            calcBinaryUIImageWithFixedThreshold()
        }
    }
    
    func thresholdChanged(_: Int) {
        if binaryImagePanel!.useAdaptiveThreshold {
            calcBinaryUIImageWithAdaptiveThreshold()
        } else {
            calcBinaryUIImageWithFixedThreshold()
        }
    }
    
    func kernelSizeChanged(_: Int) {
        if binaryImagePanel!.useAdaptiveThreshold {
            calcBinaryUIImageWithAdaptiveThreshold()
        }
    }
}
