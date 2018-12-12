//
//  Utils.swift
//  RythmRunner
//
//  Created by Jaime on 11/12/2018.
//  Copyright © 2018 phoenix. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(_ hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
}


func *(left: CGFloat, right: Int) -> CGFloat {
    return left *  CGFloat(right)
}

func *(left: Int, right: CGFloat) -> CGFloat {
    return right *  CGFloat(left)
}

func /(left: CGFloat, right: Int) -> CGFloat {
    return left / CGFloat(right)
}

func /(left: Int, right: CGFloat) -> CGFloat {
    return CGFloat(left) / right   
}
