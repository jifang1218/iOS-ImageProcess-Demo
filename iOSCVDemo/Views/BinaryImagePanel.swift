//
//  BinaryImagePanel.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-08-01.
//

import UIKit

class BinaryImagePanel : ImageEditPanel, IMSliderDelegate {
    
    var delegate : BinaryImagePanelDelegate?
    
    private var adaptiveThresholdSwitch : UISwitch
    private var thresholdStepper : UIStepper
    private var kernelSizeStepper : UIStepper
    private var thresholdLabel : UILabel
    private var kernelSizeLabel : UILabel
    private var thresholdSlider : IMSlider
    private var adaptiveThresholdPanel : UIView
    
    var useAdaptiveThreshold : Bool {
        get {
            return adaptiveThresholdSwitch.isOn
        }
    }
    
    var threshold : CGFloat {
        get {
            if useAdaptiveThreshold {
                return thresholdStepper.value
            } else {
                return CGFloat(thresholdSlider.value)
            }
        }
    }
    
    var kernelSize : Int {
        get {
            return Int(kernelSizeStepper.value)
        }
    }
    
    override init(frame: CGRect) {
        thresholdStepper = UIStepper()
        kernelSizeStepper = UIStepper()
        adaptiveThresholdSwitch = UISwitch()
        thresholdLabel = UILabel()
        kernelSizeLabel = UILabel()
        adaptiveThresholdPanel = UIView(frame: frame)
        thresholdSlider = IMSlider(frame:frame)
        super.init(frame: frame)
        setupView(frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createAdaptiveSwitchView(_ frame:CGRect)->UIView {
        let gap = 5.0
        
        // adaptive switch
        let view = UIView()
        view.addSubview(adaptiveThresholdSwitch)
        adaptiveThresholdSwitch.sizeToFit()
        adaptiveThresholdSwitch.isOn = false
        adaptiveThresholdSwitch.addTarget(self,
                                          action:#selector(adaptiveThresholdSwitchValueChanged(_:)),
                                          for: .valueChanged)
        let label = UILabel()
        label.text = "Use Adaptive Threshold"
        label.textColor = .systemYellow
        view.addSubview(label)
        label.sizeToFit()
        var frame = label.bounds
        frame.origin.x = adaptiveThresholdSwitch.frame.origin.x + adaptiveThresholdSwitch.frame.size.width + gap
        label.frame = frame
        
        view.frame.size.width = adaptiveThresholdSwitch.bounds.size.width + label.bounds.size.width + gap
        view.frame.size.height = adaptiveThresholdSwitch.bounds.size.height
        
        return view
    }
    
    private func constructThresholdSlider()->IMSlider {
        thresholdSlider.title = "Threshold: "
        thresholdSlider.min = 0
        thresholdSlider.max = 255
        thresholdSlider.value = 128
        thresholdSlider.delegate = self
        
        return thresholdSlider
    }
    
    override func reset() {
        adaptiveThresholdSwitch.isOn = false
        thresholdSlider.value = 128
        thresholdStepper.value = 10
        kernelSizeStepper.value = 5
        adaptiveThresholdSwitchValueChanged(adaptiveThresholdSwitch)
    }
    
    private func constructAdaptiveThresholdPanel() -> UIView {
        let gap = 5.0
        
        // left
        var view = UIView()
        var label = UILabel()
        label.text = "Threshold: "
        label.textColor = .systemYellow
        label.textAlignment = .right
        view.addSubview(label)
        label.sizeToFit()
        
        thresholdStepper.value = 10
        thresholdStepper.minimumValue = 0
        thresholdStepper.maximumValue = 100
        thresholdStepper.tintColor = .systemYellow
        view.addSubview(thresholdStepper)
        thresholdStepper.sizeToFit()
        thresholdStepper.addTarget(self,
                                   action: #selector(thresholdStepperValueChanged(_:)),
                                   for: .valueChanged)
        
        thresholdLabel.text = String(thresholdStepper.value)
        thresholdLabel.textColor = .systemYellow
        thresholdLabel.textAlignment = .right
        view.addSubview(thresholdLabel)
        thresholdLabel.sizeToFit()
        
        // layout left
        var frame = label.bounds
        frame.origin.y = label.frame.origin.y + label.bounds.size.height
        thresholdLabel.frame = frame
        
        frame = thresholdStepper.bounds
        frame.origin.x = label.frame.origin.x + label.bounds.size.width + gap
        frame.origin.y = thresholdLabel.frame.origin.y + thresholdLabel.bounds.size.height - frame.size.height
        thresholdStepper.frame = frame
        
        frame = view.frame
        frame.size.width = label.bounds.size.width + thresholdStepper.bounds.size.width + gap
        frame.size.height = label.bounds.size.height + thresholdLabel.bounds.size.height
        view.frame = frame
        adaptiveThresholdPanel.addSubview(view)
        
        // right
        view = UIView()
        label = UILabel()
        label.text = "Block: "
        label.textColor = .systemYellow
        label.textAlignment = .right
        view.addSubview(label)
        label.sizeToFit()
        
        kernelSizeStepper.value = 5
        kernelSizeStepper.stepValue = 2
        kernelSizeStepper.minimumValue = 3
        kernelSizeStepper.maximumValue = 99
        kernelSizeStepper.tintColor = .systemYellow
        view.addSubview(kernelSizeStepper)
        kernelSizeStepper.sizeToFit()
        kernelSizeStepper.addTarget(self,
                                   action: #selector(kernelSizeStepperValueChanged(_:)),
                                   for: .valueChanged)
        
        kernelSizeLabel.text = String(kernelSizeStepper.value)
        kernelSizeLabel.textColor = .systemYellow
        kernelSizeLabel.textAlignment = .right
        view.addSubview(kernelSizeLabel)
        kernelSizeLabel.sizeToFit()
        
        // layout right
        frame = label.bounds
        frame.origin.y = label.frame.origin.y + label.bounds.size.height
        kernelSizeLabel.frame = frame
        
        frame = kernelSizeStepper.bounds
        frame.origin.x = label.frame.origin.x + label.bounds.size.width + gap
        frame.origin.y = kernelSizeLabel.frame.origin.y + kernelSizeLabel.bounds.size.height - frame.size.height
        kernelSizeStepper.frame = frame
        
        frame = view.frame
        frame.size.width = label.bounds.size.width + kernelSizeStepper.bounds.size.width + gap
        frame.size.height = label.bounds.size.height + kernelSizeLabel.bounds.size.height
        frame.origin.x = adaptiveThresholdPanel.bounds.size.width - frame.size.width
        view.frame = frame
        adaptiveThresholdPanel.addSubview(view)
        view.bringSubviewToFront(kernelSizeStepper)
        
        return adaptiveThresholdPanel
    }
    
    private func setupView(_ aFrame:CGRect) {
        let adaptiveSwitchView = createAdaptiveSwitchView(aFrame)
        thresholdSlider = constructThresholdSlider()
        adaptiveThresholdPanel = constructAdaptiveThresholdPanel()
        
        addSubview(adaptiveSwitchView)
        var frame = adaptiveSwitchView.frame
        frame.origin.x = (aFrame.size.width - adaptiveSwitchView.bounds.size.width) / 2
        adaptiveSwitchView.frame = frame
        
        frame = thresholdSlider.frame
        frame.origin.y = adaptiveSwitchView.frame.origin.y + adaptiveSwitchView.bounds.size.height
        //frame.size.width = adaptiveSwitchView.bounds.size.width
        frame.size.width = aFrame.size.width
        thresholdSlider.frame = frame
        
        frame = adaptiveThresholdPanel.frame
        frame.origin.y = adaptiveSwitchView.frame.origin.y + adaptiveSwitchView.bounds.size.height
        frame.size.width = aFrame.width
        adaptiveThresholdPanel.frame = frame
        
        thresholdSlider.removeFromSuperview()
        adaptiveThresholdPanel.removeFromSuperview()
        if adaptiveThresholdSwitch.isOn {
            addSubview(adaptiveThresholdPanel)
        } else {
            addSubview(thresholdSlider)
        }
        
        self.bringSubviewToFront(resetButton)
    }
    
    @objc private func adaptiveThresholdSwitchValueChanged(_ sender: UISwitch) {
        thresholdSlider.removeFromSuperview()
        adaptiveThresholdPanel.removeFromSuperview()
        if sender.isOn {
            addSubview(adaptiveThresholdPanel)
//            NSLog("adaptiveThresholdSwitchValueChanged: isOn")
        } else {
            addSubview(thresholdSlider)
//            NSLog("adaptiveThresholdSwitchValueChanged: isOff")
        }
        delegate?.useAdaptiveThresholdSwitchChanged(useApativeThreshold: sender.isOn)
    }
    
    @objc private func thresholdStepperValueChanged(_ sender: UIStepper) {
        thresholdLabel.text = String(Int(sender.value))
        delegate?.thresholdChanged(Int(sender.value))
//        NSLog("thresholdStepperValueChanged: %d", Int(sender.value))
    }
    
    @objc private func kernelSizeStepperValueChanged(_ sender: UIStepper) {
        kernelSizeLabel.text = String(Int(sender.value))
        delegate?.kernelSizeChanged(Int(sender.value))
//        NSLog("kernelSizeStepperValueChanged: %d", Int(sender.value))
    }
    
    // from IMSlider
    func sliderValueChanged(value:Float, sender:IMSlider) {
        delegate?.thresholdChanged(Int(sender.value))
    }
}

@objc protocol BinaryImagePanelDelegate {
    
    @objc func useAdaptiveThresholdSwitchChanged(useApativeThreshold:Bool)
    
    @objc func thresholdChanged(_ :Int)
    
    @objc func kernelSizeChanged(_ :Int)
}
