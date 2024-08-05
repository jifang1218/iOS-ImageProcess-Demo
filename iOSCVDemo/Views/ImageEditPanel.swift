//
//  ImageEditPanel.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-30.
//

import UIKit

class ImageEditPanel : UIView {
    
    let resetButton : UIButton
    var imgEditDelegate : ImageEditPanelDelegate?
    
    override init(frame: CGRect) {
        resetButton = UIButton(type: .system)
        super.init(frame: frame)
        setupView(frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(_ frame:CGRect) {
        resetButton.setTitle("Reset", for: UIControl.State.normal)
        resetButton.setTitleColor(.systemYellow, for: .normal)
        addSubview(resetButton)
        resetButton.sizeToFit()
        var frame = resetButton.bounds
        let gap = 5.0
        frame.origin.x = bounds.size.width - frame.size.width - gap
        resetButton.frame = frame
//        resetButton.backgroundColor = .blue
        resetButton.addTarget(self, action: #selector(resetButtonTappd(_:)), for: .touchUpInside)
    }
    
    func reset() {
    }
    
    @objc func resetButtonTappd(_ sender:UIButton) {
        reset()
        imgEditDelegate?.reset(self)
    }
}

@objc protocol ImageEditPanelDelegate {
    @objc func reset(_ panel:ImageEditPanel)
}

