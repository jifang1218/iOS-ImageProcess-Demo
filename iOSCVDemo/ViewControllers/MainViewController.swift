//
//  MainViewController.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

import UIKit

class MainViewController : UINavigationController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(rootViewController: FileListViewController())
    }
}

