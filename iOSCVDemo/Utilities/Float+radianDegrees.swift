//
//  Float+radianDegrees.swift
//  iOSCVDemo
//
//  Created by jifang on 2024-07-31.
//

import Foundation

extension Float {
    var degreesToRadians: Float {
        return self * Float.pi / 180.0
    }
    
    var radiansToDegrees: Float {
        return self * 180.0 / Float.pi
    }
}
