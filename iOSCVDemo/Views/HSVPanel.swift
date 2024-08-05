//
//  HSVPanel.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-30.
//

import UIKit

class HSVPanel : ImageEditPanel, IMSliderDelegate {
    private var hueSlider : IMSlider
    private var saturationSlider : IMSlider
    private var lightnessSlider : IMSlider
    
    var delegate : HSVPanelDelegate?
    
    var hueValue: Float {
        get {
            return hueSlider.value
        } set {
            if hueSlider.value != newValue {
                hueSlider.value = newValue
            }
        }
    }
    
    var saturationValue : Float {
        get {
            return saturationSlider.value
        } set {
            if saturationSlider.value != newValue {
                saturationSlider.value = newValue
            }
        }
    }
    
    var lightnessValue : Float {
        get {
            return lightnessSlider.value
        } set {
            if lightnessSlider.value != newValue {
                lightnessSlider.value = newValue
            }
        }
    }
    
    override init(frame: CGRect) {
        hueSlider = IMSlider(frame:frame)
        saturationSlider = IMSlider(frame:frame)
        lightnessSlider = IMSlider(frame:frame)
        super.init(frame: frame)
        setupView(frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reset() {
        hueValue = 0
        saturationValue = 0
        lightnessValue = 0
    }
    
    private func setupView(_ frame:CGRect) {
        let margin = 15.0
        hueSlider.min = -180
        hueSlider.max = 180
        hueSlider.value = 0
        hueSlider.title = "Hue: "
        hueSlider.frame.origin.y = margin
        hueSlider.sizeToFit()
        hueSlider.delegate = self
        addSubview(hueSlider)
        
        saturationSlider.min = -100
        saturationSlider.max = 100
        saturationSlider.value = 0
        saturationSlider.title = "Saturation: "
        saturationSlider.frame.origin.y = hueSlider.frame.origin.y + hueSlider.frame.size.height + margin
        saturationSlider.sizeToFit()
        saturationSlider.delegate = self
        addSubview(saturationSlider)
        
        lightnessSlider.min = -100
        lightnessSlider.max = 100
        lightnessSlider.value = 0
        lightnessSlider.title = "Lightness: "
        lightnessSlider.frame.origin.y = saturationSlider.frame.origin.y + saturationSlider.frame.size.height + margin
        lightnessSlider.sizeToFit()
        lightnessSlider.delegate = self
        addSubview(lightnessSlider)
        
        self.bringSubviewToFront(resetButton)
    }
    
    func sliderValueChanged(value:Float, sender:IMSlider) {
        if let d = delegate {
            d.hsvValueChanged(hue: self.hueValue, saturation: self.saturationValue, lightness: self.lightnessValue)
        }
    }
}

@objc protocol HSVPanelDelegate {
    @objc func hsvValueChanged(hue:Float, saturation:Float, lightness:Float)
}


