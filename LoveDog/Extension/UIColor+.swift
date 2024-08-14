//
//  UIColor+.swift
//  LoveDog
//
//  Created by 홍정민 on 8/14/24.
//

import UIKit

extension UIColor {
    static let main = UIColor.init(rgb: 0x48C6EF)
    static let dark_gray = UIColor.init(rgb: 0x8C8C8C)
    static let deep_gray = UIColor.init(rgb: 0x4D5652)
    static let black = UIColor.init(rgb: 0x000000)
    static let light_gray = UIColor.init(rgb: 0xF2F2F2)
    static let white = UIColor.init(rgb: 0xFFFFFF)
    static let coral = UIColor.init(rgb: 0xF04452)
    
    convenience init(rgb: UInt) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}
