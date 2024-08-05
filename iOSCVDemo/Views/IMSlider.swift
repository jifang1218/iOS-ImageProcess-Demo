//
//  IMSlider.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-30.
//

import UIKit

class IMSlider: UIView {
    private var minLabel: UILabel
    private var currLabel: UILabel
    private var slider: UISlider
    private var titleLabel : UILabel
    
    var previousValue: Float = 0.0
    
    var delegate : IMSliderDelegate?
    
    var min: Float {
        get {
            return slider.minimumValue
        }
        set {
            if newValue != slider.minimumValue {
                slider.minimumValue = newValue
                refreshView()
            }
        }
    }
    
    var max: Float {
        get {
            return slider.maximumValue
        }
        set {
            if newValue != slider.maximumValue {
                slider.maximumValue = newValue
                refreshView()
            }
        }
    }
    
    var value: Float {
        get {
            return slider.value
        }
        set {
            if newValue != slider.value {
                slider.value = newValue
                previousValue = newValue
                refreshView()
            }
        }
    }
    
    var title : String {
        get {
            return titleLabel.text!
        } set {
            if newValue != titleLabel.text {
                titleLabel.text = newValue
                refreshView()
            }
        }
    }
    
    override init(frame: CGRect) {
        minLabel = UILabel()
        currLabel = UILabel()
        slider = UISlider()
        titleLabel = UILabel()
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(minLabel)
        addSubview(slider)
        addSubview(currLabel)
        titleLabel.textColor = .systemYellow
        minLabel.textColor = .systemYellow
        currLabel.textColor = .systemYellow
        slider.addTarget(self,
                         action: #selector(sliderValueChanged(_:)),
                         for: .valueChanged)
        refreshView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func refreshView() {
        minLabel.text = String(format: "%3d", Int(slider.minimumValue))
        currLabel.text = String(format: "%3d", Int(slider.value))
        minLabel.sizeToFit()
        currLabel.sizeToFit()
        titleLabel.sizeToFit()
        
        let margin = 20.0
        let gap = 5.0
        
        // title
        titleLabel.frame.origin.x = margin
        
        // min
        var frame = minLabel.bounds
        frame.origin.x = margin
        frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height
        frame.size.width += gap
        minLabel.frame = frame
        
        // curr
        frame = currLabel.bounds
        frame.size.width = 40
        frame.origin.x = self.bounds.size.width - currLabel.bounds.size.width - margin
        frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height
        currLabel.frame = frame
        
        // slider
        frame.origin.x = minLabel.frame.origin.x + minLabel.frame.size.width
        frame.size.width = currLabel.frame.origin.x - minLabel.frame.origin.x - minLabel.frame.size.width
        frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height
        slider.frame = frame
        
        // self
        let maxH = Swift.max(minLabel.bounds.size.height, currLabel.bounds.size.height, slider.bounds.size.height)
        self.frame.size.height = maxH + titleLabel.bounds.size.height
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        if Int(sender.value) != Int(previousValue) {
            previousValue = sender.value
            currLabel.text = String(format: "%3d", Int(sender.value))
            if let d = delegate {
                d.sliderValueChanged?(value: sender.value, sender:self)
            }
        }
    }
}

@objc protocol IMSliderDelegate {
    @objc optional func sliderValueChanged(value:Float, sender:IMSlider)
}
